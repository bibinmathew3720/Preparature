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
        return true
    }
}

extension EventsVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventsCell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath) as! EventsTVC
        eventsCell.eventItem(event:self.eventsArray[indexPath.row] )
        return eventsCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aspectRatio:CGFloat = 0.5
        return aspectRatio * UIScreen.main.bounds.size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == (eventsArray.count-1)){
            self.getAllEventsApi()
        }
    }
}
