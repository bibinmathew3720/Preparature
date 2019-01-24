//
//  AddEventViewController.swift
//  Preparture
//
//  Created by praveen raj on 07/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit
import MapKit

enum PickerType{
    case dateOnlyPickerType
    case timeOnlyPickerType
    case categoryPicker
}

class AddEventViewController: BaseViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var tfType: UITextField!
    @IBOutlet var pickerViewType: UIPickerView!
    @IBOutlet var toolBarPicker: UIToolbar!
    var selectedIndex:NSInteger = 0
    @IBOutlet weak var tfEventName: UITextField!
    @IBOutlet weak var tfAuthorName: UITextField!
    @IBOutlet weak var tfExpense: UITextField!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var tfTime: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet weak var textViewTravelExp: UITextView!
    @IBOutlet weak var textViewComments: UITextView!
    @IBOutlet weak var buttonStarFirst: UIButton!
    @IBOutlet weak var buttonStarSecond: UIButton!
    @IBOutlet weak var buttonStarThird: UIButton!
    @IBOutlet weak var buttonStarFourth: UIButton!
    @IBOutlet weak var buttonStarFifth: UIButton!
    var rateIndex:Int = 0
    var mapItem:MKMapItem?
    var categoryResponseModel:GetAllCategoryResponseModel?
    
    var pickType:PickerType = .dateOnlyPickerType
    var addEvent = AddEvent()
    
    override func initView() {
        super.initView()
        initialisation()
        customization()
    }
    
    func initialisation(){
        tfDate.inputAccessoryView = toolBarPicker
        tfDate.inputView = datePicker
        tfTime.inputAccessoryView = toolBarPicker
        tfTime.inputView = datePicker
    }
    
    func customization() {
        tfType.inputView = pickerViewType
        tfType.inputAccessoryView = toolBarPicker
        pickerViewType.translatesAutoresizingMaskIntoConstraints = false
        toolBarPicker.translatesAutoresizingMaskIntoConstraints = false
        
        self.textViewTravelExp.layer.cornerRadius = 5
        self.textViewTravelExp.layer.borderColor = UIColor.lightGray.cgColor
        self.textViewTravelExp.layer.borderWidth = 1
        
        self.textViewComments.layer.cornerRadius = 5
        self.textViewComments.layer.borderColor = UIColor.lightGray.cgColor
        self.textViewComments.layer.borderWidth = 1
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func textFieldAction(_ sender: UITextField) {
        if sender == tfEventName{
            if let textString = sender.text{
                addEvent.eventName = textString
            }
        }
        else if sender == tfAuthorName{
            if let textString = sender.text{
                addEvent.authorName = textString
            }
        }
        else if sender == tfExpense{
            if let textString = sender.text{
                addEvent.eventCost = textString
            }
        }
    }
    //MARK: -> ------ UIPickerView Delegates ------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let catResposne = self.categoryResponseModel{
            return catResposne.categoryItems.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let catResposne = self.categoryResponseModel{
            return catResposne.categoryItems[row].categoryName
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
    
    //MARK:- UIView Action Methods
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func starButtonAction(_ sender: UIButton) {
        settingRating(rating: sender.tag)
    }
    
    func settingRating(rating:Int){
        addEvent.eventRating = rating
        buttonStarFirst.isSelected = false
        buttonStarSecond.isSelected = false
        buttonStarThird.isSelected = false
        buttonStarFourth.isSelected = false
        buttonStarFifth.isSelected = false
        if rating == 1 {
            buttonStarFirst.isSelected = true
        }
        else if (rating == 2){
            buttonStarFirst.isSelected = true
            buttonStarSecond.isSelected = true
        }
        else if (rating == 3){
            buttonStarFirst.isSelected = true
            buttonStarSecond.isSelected = true
            buttonStarThird.isSelected = true
        }
        else if (rating == 4){
            buttonStarFirst.isSelected = true
            buttonStarSecond.isSelected = true
            buttonStarThird.isSelected = true
            buttonStarFourth.isSelected = true
        }
        else if (rating == 5){
            buttonStarFirst.isSelected = true
            buttonStarSecond.isSelected = true
            buttonStarThird.isSelected = true
            buttonStarFourth.isSelected = true
            buttonStarFifth.isSelected = true
        }
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        addEventApi()
    }
    
    @IBAction func actionToolbarDone(_ sender: Any) {
        if pickType == .categoryPicker {
            guard let code = categoryResponseModel?.categoryItems[selectedIndex] else {
                return
            }
            tfType.text = code.categoryName
        }
        else if pickType == .dateOnlyPickerType{
            let dateString = CCUtility.stringFromDateWithYear(date:datePicker.date)
            tfDate.text = dateString
            addEvent.eventDate = CCUtility.dateString(with:dateString , from: "MMM, dd yyyy", to: "yyyy-MM-dd")
            print(addEvent.eventDate)
        }
        else if pickType == .timeOnlyPickerType{
            let timeString = CCUtility.stringFromDateOnlyYear(date:datePicker.date)
            tfTime.text = timeString
            addEvent.eventTime = CCUtility.dateString(with: timeString, from: "hh:mm a", to: "hh:mm a")
            print(addEvent.eventTime)
        }
        view.endEditing(true)
    }
    
    @IBAction func actionToolbarCancel(_ sender: Any) {
         view.endEditing(true)
    }
    
    @IBAction func actionAddPlaces(_ sender: Any) {
        let vc:AddPlacesViewController = AddPlacesViewController(nibName: "AddPlacesViewController", bundle: nil)
        self.navigationController?.pushViewController(vc , animated: true)
    }
    
    //MARK:- Add Event Api integration
    
    func addEventApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().addEventApi(with:addEvent.getRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? GetAllCategoryResponseModel{
                
                let vc:AddPlacesViewController = AddPlacesViewController(nibName: "AddPlacesViewController", bundle: nil)
                self.navigationController?.pushViewController(vc , animated: true)
                //if model.statusCode == 1{
                //                }
                //                else{
                //                    CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.statusMessage, parentController: self)
                //                }
            } else {
                //                if let model = model as? stat{
                //                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.statusMessage, parentController: self)
                //                }
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

extension AddEventViewController:UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfLocation {
            if tfLocation.text?.count != 0 {
                let request = MKLocalSearchRequest()
                request.naturalLanguageQuery = textField.text
                let search = MKLocalSearch(request: request)
                search.start { response, error in
                    guard let response = response else {
                        print("There was an error searching for: \(String(describing: request.naturalLanguageQuery)) error: \(String(describing: error))")
                        return
                    }
                    var array:[MKMapItem] = response.mapItems
                    self.mapItem = array[0]
                }
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfDate{
            pickType = .dateOnlyPickerType
            datePicker.datePickerMode = .date
        }
        else if textField == tfTime {
            pickType = .timeOnlyPickerType
            datePicker.datePickerMode = .time
        }
        else if textField == tfType {
            pickType = .categoryPicker
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfType {
            tfType.inputView = pickerViewType
            tfType.inputAccessoryView = toolBarPicker
            pickerViewType.translatesAutoresizingMaskIntoConstraints = false
            toolBarPicker.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == textViewTravelExp {
            if textViewTravelExp.text == "Travel Experience" {
                textViewTravelExp.text = ""
            }
        } else {
            if textViewComments.text == "Comments" {
                textViewComments.text = ""
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        if textView == textViewTravelExp{
            if let textString = textView.text{
                addEvent.travelExperience = textString
            }
        }
        else if textView == textViewComments{
            if let textString = textView.text{
                addEvent.comment = textString
            }
        }
        print(textView.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfEventName{
            tfAuthorName.becomeFirstResponder()
        }
        else if textField == tfAuthorName{
            tfExpense.becomeFirstResponder()
        }
        
        return true
    }
}
