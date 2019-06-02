//
//  AddItineraryVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 2/2/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddItineraryVC: BaseViewController {

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var addItineraryTV: UITableView!
    @IBOutlet weak var itineraryNameTF: UITextField!
    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet weak var endDateTF: UITextField!
    var eventItem:EventItem?
    
    @IBOutlet var toolBar: UIToolbar!
    var addItinerary = AddItinerary()
    var textFieldType:TextFieldType = .textFieldCheckIn
    var selIndex:Int = -1
    override func initView() {
        super.initView()
        initialisation()
    }
    
    func initialisation(){
        tableCellRegistration()
        addItineraryTV.estimatedRowHeight = 60
        addItineraryTV.rowHeight = UITableViewAutomaticDimension
        startDateTF.inputView = datePicker
        startDateTF.inputAccessoryView = toolBar
        endDateTF.inputView = datePicker
        endDateTF.inputAccessoryView = toolBar
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        if let _eventItem = eventItem{
            addItinerary.eventId = _eventItem.eventId
            addItinerary.categoryId = _eventItem.categoryId
        }
    }
    
    func tableCellRegistration(){
        addItineraryTV.register(UINib.init(nibName: "AdditineraryTVC", bundle: nil), forCellReuseIdentifier: "addItCell")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toolBarDoneButtonAction(_ sender: UIBarButtonItem) {
        if textFieldType == .textFieldCheckIn{
            let landMark = self.addItinerary.landMarks[self.selIndex]
            landMark.checkInDate = CCUtility.stringFromDateAndTime(date: datePicker.date)
            addItineraryTV.reloadData()
        }
        else if textFieldType == .textFieldCheckOut{
            let landMark = self.addItinerary.landMarks[self.selIndex]
            landMark.checkOutDate = CCUtility.stringFromDateAndTime(date: datePicker.date)
            addItineraryTV.reloadData()
        }
        else if textFieldType == .textFieldStartDate{
            addItinerary.itineraryStartDate = CCUtility.stringFromDateAndTime(date: datePicker.date)
            startDateTF.text = addItinerary.itineraryStartDate
        }
        else if textFieldType == .textFieldEndDate{
            addItinerary.itineraryEndDate = CCUtility.stringFromDateAndTime(date: datePicker.date)
            endDateTF.text = addItinerary.itineraryEndDate
        }
        self.view.endEditing(true)
    }
    
    @IBAction func toolBarCancelButtonAction(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if sender == itineraryNameTF{
            if let textString = sender.text{
                addItinerary.itineraryName = textString
            }
        }
    }
    
    @IBAction func addLandMarkButtonAction(_ sender: UIButton) {
        let addLandMark = AddLandmark()
        self.addItinerary.landMarks.insert(addLandMark, at: 0)
        addItineraryTV.reloadData()
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        if isValid(){
            callingAddItineraryApi()
        }
    }
    
    func isValid()->Bool{
        if !addItinerary.itineraryName.isValidString(){
            if !addItinerary.itineraryStartDate.isValidString(){
                if !addItinerary.itineraryEndDate.isValidString(){
                    return true
                }
                else{
                    CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: "Please select end date", parentController: self)
                    return false
                }
            }
            else{
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: "Please select start date", parentController: self)
                return false
            }
        }
        else{
            CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: "Please enter trip name", parentController: self)
            return false
        }
    }
    
    //MARK:- Add Event Api integration
    
    func callingAddItineraryApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        EventManager().callingAddItineraryApi(with:addItinerary.getRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? GetAllCategoryResponseModel{
                if model.statusCode == 1{
                    CCUtility.showDefaultAlertwithCompletionHandler(_title: Constant.AppName, _message: "Event created successfully", parentController: self, completion: { (status) in
                        self.dismiss(animated: false, completion: nil)
                    })
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
}

extension AddItineraryVC:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.addItinerary.landMarks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addItCell", for: indexPath) as!AdditineraryTVC
        cell.tag = indexPath.section
        cell.delegate = self
        cell.setLandMarkDetails(landMark:self.addItinerary.landMarks[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}

extension AddItineraryVC:AddItineraryTVCDelegate{
    func textFieldEditeChangedDelegate(tag: Int, textField: UITextField, textFieldType:TextFieldType) {
        let landMark = self.addItinerary.landMarks[self.selIndex]
        if textFieldType == .textFieldLandmarkName{
            if let txtString = textField.text{
                landMark.landmarkName = txtString
            }
        }
//        else if textFieldType == .textFieldLatitude{
//            if let txtString = textField.text{
//                //landMark.landmarkLatitude = txtString
//            }
//        }
//        else if textFieldType == .textFieldLongitude{
//            if let txtString = textField.text{
//                //landMark.landmarkLongitude = txtString
//            }
//        }
    
    }
    
    func textFieldShouldBeginDelegate(textField: UITextField, type: TextFieldType, tag: Int) {
        if type == .textFieldCheckIn || type == .textFieldCheckOut{
            textField.inputView = datePicker
            textField.inputAccessoryView = toolBar
        }
        textFieldType = type
        selIndex = tag
    }
    
    func landMarkButtonActionDelegate(tag: Int) {
        selIndex = tag
        let addPlacesVC = AddPlacesViewController.init(nibName: "AddPlacesViewController", bundle: nil)
        addPlacesVC.delegate = self
        self.navigationController?.pushViewController(addPlacesVC, animated: true)
    }
}

extension AddItineraryVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == itineraryNameTF{
            startDateTF.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == startDateTF{
            textFieldType = .textFieldStartDate
        }
        else if textField == endDateTF{
            textFieldType = .textFieldEndDate
        }
        return true
    }
}

extension AddItineraryVC:AddPlacesVCDelegate{
    func selectedLocationDelegate(location: GMSPlace) {
        let landMark = self.addItinerary.landMarks[self.selIndex]
        landMark.landmarkLatitude = location.coordinate.latitude
        landMark.landmarkLongitude = location.coordinate.longitude
        landMark.landmarkName = location.name
        addItineraryTV.reloadData()
    }
    
    func selectedLocationDelegateWithMarker(location: GMSMarker) {
        let landMark = self.addItinerary.landMarks[self.selIndex]
        landMark.landmarkLatitude = location.position.latitude
        landMark.landmarkLongitude = location.position.longitude
        landMark.landmarkName = location.title ?? ""
        addItineraryTV.reloadData()
    }
}
