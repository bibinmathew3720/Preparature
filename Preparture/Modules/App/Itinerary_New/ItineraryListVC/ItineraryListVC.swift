//
//  ItineraryListVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 1/26/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit

class ItineraryListVC: BaseViewController {
    @IBOutlet weak var itineraryListTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    var eventItem:EventItem?
    var selIndexes = [Int]()
    override func initView() {
        super.initView()
        initialisation()
        callingGetEventDetailsApi()
    }
    
    func initialisation(){
        tableCellRegistration()
        itineraryListTableView.estimatedRowHeight = 60
        itineraryListTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableCellRegistration(){
        itineraryListTableView.register(UINib.init(nibName: "ItineraryListTVC", bundle: nil), forCellReuseIdentifier: "itineraryCell")
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func plusButtonAction(_ sender: UIButton) {
        let addItineraryVC = AddItineraryVC.init(nibName: "AddItineraryVC", bundle: nil)
        self.navigationController?.pushViewController(addItineraryVC, animated: true)
    }
    
    //MARK:- Get Event Details Api Integration
    
    func callingGetEventDetailsApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        EventManager().callingEventDetailsApi(with: getEventDetailsRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? EventDetailResponseModel{
                if model.statusCode == 1{
                    self.eventItem = model.eventItem
                    self.itineraryListTableView.reloadData()
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
            } else {
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
            print(ErrorType)
        }
    }
    
    func getEventDetailsRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let eventIt = eventItem {
            dict.updateValue(eventIt.eventId as AnyObject, forKey: "event_id")
        }
        if let user = User.getUser(){
            dict.updateValue(user.userId as AnyObject, forKey: "user_id")
        }
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
    func showEmptyView(){
        if let _eventItem = self.eventItem{
            if _eventItem.itineraries.count == 0{
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

extension ItineraryListVC:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let eventIt = self.eventItem{
            return eventIt.itineraries.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let eventIt = self.eventItem{
            if selIndexes.contains(section) {
                return eventIt.itineraries[section].landMarks.count
            }
            else{
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itineraryCell", for: indexPath) as!ItineraryListTVC
        cell.tag = indexPath.section
        cell.directionButton.tag = indexPath.row
        if let eventIt = self.eventItem{
            cell.setLandMarkDetails(landMarkDetails:eventIt.itineraries[indexPath.section].landMarks[indexPath.row])
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerViewCustom = (Bundle.main.loadNibNamed("ItineraryHeaderView", owner: self, options: nil)![0] as? ItineraryHeaderView)!
        headerViewCustom.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        if let eventIt = eventItem{
            headerViewCustom.setItineraryDetails(itineraryDetails:eventIt.itineraries[section])
        }
        headerViewCustom.delegate = self
        headerViewCustom.openCloseButton.isSelected = selIndexes.contains(section)
        headerViewCustom.openCloseButton.tag = section
        return headerViewCustom
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width:tableView.frame.size.width, height:40))
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
}

extension ItineraryListVC:ItineraryListTVCDelegate{
    func directionButtonActionDelegate(section: NSInteger, row: NSInteger) {
        if let eventIt = self.eventItem{
            let landMarkDetails = eventIt.itineraries[section].landMarks[row]
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
            {
                let urlString = "http://maps.google.com/?daddr=\(landMarkDetails.landLatitude),\(landMarkDetails.landLongitude)&directionsmode=driving"
                UIApplication.shared.openURL(URL(string: urlString)!)
            }
            else
            {
                let urlString = "http://maps.apple.com/maps?daddr=\(landMarkDetails.landLatitude),\(landMarkDetails.landLongitude)&dirflg=d"
                UIApplication.shared.openURL(URL(string: urlString)!)
            }
        }
    }
}

extension ItineraryListVC:ItineraryHeaderViewDelegate{
    func openButtonActionDelegate(button: UIButton) {
        if selIndexes.contains(button.tag){
            if let index = selIndexes.index(of: button.tag){
                selIndexes.remove(at: index)
            }
        }
        else{
           selIndexes.append(button.tag)
        }
        itineraryListTableView.reloadData()
    }
}
