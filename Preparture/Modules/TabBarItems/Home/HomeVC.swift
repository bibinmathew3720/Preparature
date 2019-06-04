//
//  HomeVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 7/4/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController {
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    
    var itemDetail:CategoryItem?
    var eventsArray = [EventItem]()
    var eventsResponseModel:EventsResponseModel?
    
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var tableViewList: UITableView!
    var currentPage:Int = 0
    var categoryResponseModel:NSArray?
    @IBOutlet weak var empyView: UIView!
    
    override func initView() {
        super.initView()
       // eventsArray = NSMutableArray()
        self.navigationController?.navigationBar.isHidden = true
        labelHeading.text = itemDetail?.categoryName
        addShadowToAView(shadowView: searchView)
        tableCellRegistration()
        getSuggestions()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableViewList.reloadData()
    }
    
    
    func tableCellRegistration(){
        tableViewList.register(UINib.init(nibName: "HomeListTVC", bundle: nil), forCellReuseIdentifier: "homeListCell")
        tableViewList.dataSource = self
        tableViewList.delegate = self
    }
    
    func getSuggestions(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        EventManager().callingEventsApi(with: listAllEventRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? EventsResponseModel{
                if model.statusCode == 1{
                    self.currentPage = self.currentPage + 1
                    self.eventsResponseModel = model
                    self.eventsArray.append(contentsOf: model.events)
                   // self.eventsArray.addObjects(from: model.events)
                    self.tableViewList.reloadData()
                    self.showEmptyView()
                }
                else{
                    CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.statusMessage, parentController: self)
                }
                
            }
            
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
            
            print(ErrorType)
        }
    }
    
    func listAllEventRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let cat = itemDetail {
            dict.updateValue(cat.categoryID as AnyObject, forKey: "category_id")
        }
        dict.updateValue(currentPage as AnyObject, forKey: "currentpage")
        dict.updateValue(10 as AnyObject, forKey: "rowsperpage")
        if let user = User.getUser(){
            dict.updateValue(user.userId as AnyObject, forKey: "user_id")
        }
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
    func showEmptyView(){
        if eventsArray.count == 0{
           empyView.isHidden = false
        }
        else{
            empyView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- UIView Action Methods
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension HomeVC:UITableViewDataSource,UITableViewDelegate,HomeListTVCDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeListCell", for: indexPath) as!HomeListTVC
        cell.eventItem(event:self.eventsArray[indexPath.row] )
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventItem:EventItem = self.eventsArray[indexPath.row]
        let detailVC = HomeDetailViewController(nibName: "HomeDetailViewController", bundle: nil)
        detailVC.eventItem = eventItem
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == (eventsArray.count-1)){
            self.getSuggestions()
        }
    }
    
    //MARK:- HomeListTVC Delegate method
    
    func addToFavorite(tag:NSInteger, favButton:UIButton) {
        let eveItem:EventItem = self.eventsArray[tag]
        if favButton.isSelected {
            self.callingRemoveFromFavoriteApi(suggestionItem: eveItem) { (status) in
                if status {
                    eveItem.isFavourite = false
                    self.tableViewList.reloadData()
                }
            }
        }
        else{
            self.callingAddToFavoriteApi(suggestionItem: eveItem) { (status) in
                if status {
                    eveItem.isFavourite = true
                    self.tableViewList.reloadData()
                }
            }
        }
    }
    
    func doubleArrowButtonAction(tag:NSInteger){
        let itineraryVC = ItineraryListVC.init(nibName: "ItineraryListVC", bundle: nil)
        itineraryVC.eventItem = self.eventsArray[tag]
        itineraryVC.isPresent = false
         self.navigationController?.pushViewController(itineraryVC, animated: true)
    }
    
    func shareAction(tag:NSInteger){
        let suggestion:EventItem = self.eventsArray[tag]
        let textToShare = "\(suggestion.name)"
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        DispatchQueue.main.async {
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
