//
//  EventsVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 1/5/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit

class EventsVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchView: UIView!
    
    var currentPage:Int = 0
    var eventsArray = [EventItem]()
    var eventsResponseModel:EventsResponseModel?
    
    var isFromSearch:Bool = false
    var searchRequest = EventsSearchRequestModel()
    var searchResponseModel:EventsResponseModel?
    @IBOutlet weak var emptyView: UIView!
    override func initView() {
        super.initView()
        initialisation()
        tableCellRegistration()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func initialisation(){
       searchView.addCardShadow()
       getAllEventsApi()
    }
    
    func tableCellRegistration(){
        tableView.register(UINib.init(nibName: "EventsTVC", bundle: nil), forCellReuseIdentifier: "eventsCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if let _searchText = sender.text{
            searchRequest.searchText = _searchText
            if searchRequest.searchText.count == 0{
                self.isFromSearch = false
                self.view.endEditing(true)
                self.getAllEventsApi()
            }
        }
    }
    
    @IBAction func searchIconButtonAction(_ sender: UIButton) {
        searchTF.becomeFirstResponder()
    }
    
    //MARK:- Button Actions
    
    @IBAction func actionAdd(_ sender: Any) {
        let vc:AddEventViewController = AddEventViewController(nibName: "AddEventViewController", bundle: nil)
        let navController:UINavigationController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated: false, completion: nil)
    }
    
    @IBAction func reloadButtonAction(_ sender: UIButton) {
        searchRequest.searchText = ""
        searchTF.text = ""
        self.isFromSearch = false
        self.currentPage = 0
        self.eventsArray.removeAll()
        tableView.reloadData()
        self.getAllEventsApi()
    }
    
    //Get All Events Api
    
    func getAllEventsApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        EventManager().callingGetAllEventsApi(with: listAllEventsRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? EventsResponseModel{
                if model.statusCode == 1{
                    self.currentPage = self.currentPage + 1
                    self.eventsResponseModel = model
                    self.eventsArray.append(contentsOf: model.events)
                    self.tableView.reloadData()
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
    
    func listAllEventsRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        dict.updateValue(currentPage as AnyObject, forKey: "currentpage")
        dict.updateValue(10 as AnyObject, forKey: "rowsperpage")
        if let user = User.getUser(){
            dict.updateValue(user.userId as AnyObject, forKey: "user_id")
        }
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
    //Search Place Api
    
    func getAllEventsBasedOnLocationApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        EventManager().callingGetAllEventsBasedOnLocationApi(with: searchRequest.getRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? EventsResponseModel{
                if model.statusCode == 1{
                    self.searchResponseModel = model
                    self.tableView.reloadData()
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
    
    func showEmptyView(){
        if self.isFromSearch{
            if let searchResponse = self.searchResponseModel{
                if searchResponse.events.count == 0{
                    self.emptyView.isHidden = false
                }
                else{
                   self.emptyView.isHidden = true
                }
            }
        }
        else{
            if eventsArray.count == 0{
               self.emptyView.isHidden = false
            }
            else{
                self.emptyView.isHidden = true
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EventsVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        isFromSearch = true
        self.getAllEventsBasedOnLocationApi()
        return true
    }
}

extension EventsVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromSearch{
            if let searchResponse = self.searchResponseModel{
                return searchResponse.events.count
            }
            return 0
        }
        else{
            return self.eventsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventsCell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath) as! EventsTVC
        if isFromSearch{
             if let searchResponse = self.searchResponseModel{
                eventsCell.eventItem(event:searchResponse.events[indexPath.row] )
            }
        }
        else{
            eventsCell.eventItem(event:self.eventsArray[indexPath.row] )
        }
        eventsCell.tag = indexPath.row
        eventsCell.delegate = self
        return eventsCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aspectRatio:CGFloat = 0.5
        return aspectRatio * UIScreen.main.bounds.size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var eventItem:EventItem?
        if isFromSearch{
            if let searchResponse = self.searchResponseModel{
                eventItem = searchResponse.events[indexPath.row]
            }
        }
        else{
           eventItem = self.eventsArray[indexPath.row]
        }
        if let _eventItem = eventItem{
            let detailVC = HomeDetailViewController(nibName: "HomeDetailViewController", bundle: nil)
            detailVC.eventItem = _eventItem
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (!self.isFromSearch){
            if(indexPath.row == (eventsArray.count-1)){
                self.getAllEventsApi()
            }
        }
    }
}

extension EventsVC:EventsTVCDelegate{
    func favoriteButtonActionDelegate(tag: Int, favButton: UIButton) {
        var eventItem:EventItem?
        if isFromSearch{
            if let searchResponse = self.searchResponseModel{
                eventItem = searchResponse.events[tag]
            }
        }
        else{
            eventItem = self.eventsArray[tag]
        }
        if let _eventItem = eventItem{
            if favButton.isSelected {
                self.callingRemoveFromFavoriteApi(suggestionItem: _eventItem) { (status) in
                    if status {
                        _eventItem.isFavourite = false
                        self.tableView.reloadData()
                    }
                }
            }
            else{
                self.callingAddToFavoriteApi(suggestionItem: _eventItem) { (status) in
                    if status {
                        _eventItem.isFavourite = true
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func itineraryButonActionDelegate(tag: Int) {
        var eventItem:EventItem?
        if isFromSearch{
            if let searchResponse = self.searchResponseModel{
                eventItem = searchResponse.events[tag]
            }
        }
        else{
            eventItem = self.eventsArray[tag]
        }
        if let _eventItem = eventItem{
            let itineraryVC = ItineraryListVC.init(nibName: "ItineraryListVC", bundle: nil)
            itineraryVC.eventItem = _eventItem
             itineraryVC.isPresent = true
            let itineraryNavCtlr = UINavigationController.init(rootViewController: itineraryVC)
            self.present(itineraryNavCtlr, animated: true, completion: nil)
        }
    }
    
    func shareButtonActionDelegate(tag: Int) {
        var eventItem:EventItem?
        if isFromSearch{
            if let searchResponse = self.searchResponseModel{
                eventItem = searchResponse.events[tag]
            }
        }
        else{
            eventItem = self.eventsArray[tag]
        }
        if let _eventItem = eventItem{
            let textToShare = "\(_eventItem.name)"
            let objectsToShare = [textToShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            DispatchQueue.main.async {
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }
    
    
}
