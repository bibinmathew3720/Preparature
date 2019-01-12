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
    var eventsArray:NSMutableArray?
    var eventsResponseModel:EventsResponseModel?
    
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var tableViewList: UITableView!
    var currentPage:Int = 0
    var categoryResponseModel:NSArray?
    
    override func initView() {
        super.initView()
        eventsArray = NSMutableArray()
        self.navigationController?.navigationBar.isHidden = true
        labelHeading.text = itemDetail?.categoryName
        addShadowToAView(shadowView: searchView)
        tableCellRegistration()
        getSuggestions()
        // Do any additional setup after loading the view.
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
                    self.eventsArray?.addObjects(from: model.events)
                    self.tableViewList.reloadData()
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
        if let eveArray = self.eventsArray{
            return eveArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeListCell", for: indexPath) as!HomeListTVC
        if let eveArray = self.eventsArray{
            cell.eventItem(event:eveArray[indexPath.row] as! EventItem)
        }
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let eveArray = self.eventsArray{
            let eventItem:EventItem = eveArray[indexPath.row] as! EventItem
            let detailVC = HomeDetailViewController(nibName: "HomeDetailViewController", bundle: nil)
            detailVC.eventItem = eventItem
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
    //MARK:- HomeListTVC Delegate method
    
    func addToFavorite(tag:NSInteger) {
        if let eveArray = self.eventsArray{
            let eveItem:EventItem = eveArray[tag] as! EventItem
            self.callingAddToFavoriteApi(suggestionItem: eveItem) { (status) in
                if status {
                    self.tableViewList.reloadData()
                }
            }
        }
    }
    
    func doubleArrowButtonAction(tag:NSInteger){
       
    }
    
    func shareAction(tag:NSInteger){
        if let eveArray = self.eventsArray{
            let suggestion:EventItem = eveArray[tag] as! EventItem
            let textToShare = "\(suggestion.name)"
            let objectsToShare = [textToShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            DispatchQueue.main.async {
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}
