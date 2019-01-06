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
    var suggestionsArray:NSMutableArray?
    var suggestionResponseModel:SuggestionsResponseModel?
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var tableViewList: UITableView!
    var currentPage:Int = 0
    var categoryResponseModel:NSArray?
    
    override func initView() {
        super.initView()
        suggestionsArray = NSMutableArray()
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
        EventManager().callingSuggestionsApi(with: listAllEventRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? SuggestionsResponseModel{
                if model.statusCode == 1{
                    self.currentPage = self.currentPage + 1
                    self.suggestionResponseModel = model
                    self.suggestionsArray?.addObjects(from: (self.suggestionResponseModel?.events)!)
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
        dict.updateValue(itemDetail?.categoryID as AnyObject, forKey: "category_id")
        dict.updateValue(currentPage as AnyObject, forKey: "currentpage")
        dict.updateValue(10 as AnyObject, forKey: "rowsperpage")
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Add To Favorite Api integration
    
    func callingAddToFavoriteApi(suggestionItem:EventItem){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().addToFavoriteApi(with: addToFavoriteRequestBody(suggestion:suggestionItem), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AddToFavoriteResponseModel{
                if model.statusCode == 1{
                   // suggestionItem.isFavorited = true
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
            } else {
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
            print(ErrorType)
        }
    }
    
    func addToFavoriteRequestBody(suggestion:EventItem)->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let user = User.getUser() {
            dict.updateValue(user.userId as AnyObject, forKey: "user_id")
        }
        dict.updateValue(suggestion.eventId as AnyObject, forKey: "event_id")
        return CCUtility.getJSONfrom(dictionary: dict)
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
        if let sugArray = self.suggestionsArray{
            return sugArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeListCell", for: indexPath) as!HomeListTVC
        if let sugArray = self.suggestionsArray{
            cell.setSuggestionItem(suggestion:sugArray[indexPath.row] as! EventItem)
        }
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let suggestion:EventItem = self.suggestionsArray![indexPath.row] as! EventItem
        let detailVC = HomeDetailViewController(nibName: "HomeDetailViewController", bundle: nil)
        //detailVC.eventItem = suggestion
        detailVC.categoryResponseModel = categoryResponseModel
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK:- HomeListTVC Delegate method
    
    func addToFavorite(tag:NSInteger) {
        let suggestion:EventItem = self.suggestionsArray![tag] as! EventItem
        callingAddToFavoriteApi(suggestionItem:suggestion)
    }
    
    func doubleArrowButtonAction(tag:NSInteger){
       
    }
    
    func shareAction(tag:NSInteger){
        let suggestion:EventItem = self.suggestionsArray![tag] as! EventItem
        let textToShare = "\(suggestion.name)"
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        DispatchQueue.main.async {
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
