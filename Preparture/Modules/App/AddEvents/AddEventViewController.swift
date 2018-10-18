//
//  AddEventViewController.swift
//  Preparture
//
//  Created by praveen raj on 07/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit
import MapKit

class AddEventViewController: BaseViewController {

    @IBOutlet weak var tfType: UITextField!
    @IBOutlet var pickerViewType: UIPickerView!
    @IBOutlet var toolBarPicker: UIToolbar!
    var selectedIndex:NSInteger = 0
    @IBOutlet weak var tfEventName: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var tfAuthorName: UITextField!
    @IBOutlet weak var textViewTravelExp: UITextView!
    @IBOutlet weak var textViewComments: UITextView!
    @IBOutlet weak var buttonStarFirst: UIButton!
    @IBOutlet weak var buttonStarSecond: UIButton!
    @IBOutlet weak var buttonStarThird: UIButton!
    @IBOutlet weak var buttonStarFourth: UIButton!
    @IBOutlet weak var buttonStarFifth: UIButton!
    var rateIndex:Int = 0
    var mapItem:MKMapItem?
    var categoryResponseModel:NSArray?
    
    override func initView() {
        super.initView()
        
        customization()
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

    //MARK: -> ------ UIPickerView Delegates ------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if categoryResponseModel != nil {
            return categoryResponseModel!.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item:CategoryItem = categoryResponseModel![row] as! CategoryItem
        return item.categoryName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
    
    //MARK:- UIView Action Methods
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func actionStarFirst(_ sender: Any) {
        rateIndex = 1
        buttonStarFirst.isSelected = true
        buttonStarSecond.isSelected = false
        buttonStarThird.isSelected = false
        buttonStarFourth.isSelected = false
        buttonStarFifth.isSelected = false
    }
    
    @IBAction func actionStarSecond(_ sender: Any) {
        rateIndex = 2
        buttonStarFirst.isSelected = true
        buttonStarSecond.isSelected = true
        buttonStarThird.isSelected = false
        buttonStarFourth.isSelected = false
        buttonStarFifth.isSelected = false
    }
    
    @IBAction func actionStarThird(_ sender: Any) {
        rateIndex = 3
        buttonStarFirst.isSelected = true
        buttonStarSecond.isSelected = true
        buttonStarThird.isSelected = true
        buttonStarFourth.isSelected = false
        buttonStarFifth.isSelected = false
    }
    
    @IBAction func actionStarFourth(_ sender: Any) {
        rateIndex = 4
        buttonStarFirst.isSelected = true
        buttonStarSecond.isSelected = true
        buttonStarThird.isSelected = true
        buttonStarFourth.isSelected = true
        buttonStarFifth.isSelected = false
    }
    
    @IBAction func actionStarFifth(_ sender: Any) {
        rateIndex = 5
        buttonStarFirst.isSelected = true
        buttonStarSecond.isSelected = true
        buttonStarThird.isSelected = true
        buttonStarFourth.isSelected = true
        buttonStarFifth.isSelected = true
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        addEventApi()
    }
    
    @IBAction func actionToolbarDone(_ sender: Any) {
        guard let code = categoryResponseModel?[selectedIndex] else {
            return
        }
        let item:CategoryItem = code as! CategoryItem
        tfType.text = item.categoryName
    }
    
    @IBAction func actionToolbarCancel(_ sender: Any) {
    }
    
    @IBAction func actionAddPlaces(_ sender: Any) {
        let vc:AddPlacesViewController = AddPlacesViewController(nibName: "AddPlacesViewController", bundle: nil)
        self.navigationController?.pushViewController(vc , animated: true)
    }
    
    //MARK:- Add Event Api integration
    
    func addEventApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        print(addEventRequestBody())
        UserManager().addEventApi(with:addEventRequestBody(), success: {
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
    
    func addEventRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let user = User.getUser() {
            dict.updateValue(user.userId as AnyObject, forKey: "user_id")
        }
        dict.updateValue(tfEventName.text as AnyObject, forKey: "event_name")
        dict.updateValue(tfAuthorName.text as AnyObject, forKey: "author_name")
        if mapItem != nil {
            dict.updateValue(mapItem?.placemark.coordinate.latitude as AnyObject, forKey: "latitude")
            dict.updateValue(mapItem?.placemark.coordinate.longitude as AnyObject, forKey: "longitude")
            dict.updateValue(mapItem?.name as AnyObject, forKey: "location")
        }
        dict.updateValue(tfAuthorName.text as AnyObject, forKey: "travel_experience")
        dict.updateValue(tfAuthorName.text as AnyObject, forKey: "comments")
        
        dict.updateValue(rateIndex as AnyObject, forKey: "event_rate")
        if let code = categoryResponseModel?[selectedIndex] {
            let item:CategoryItem = code as! CategoryItem
            dict.updateValue(item.categoryID as AnyObject, forKey: "category_id")
        }
        
        //"event_files": "image.jpg,video.mp4" ( File names are concatenate with comma - > check API No: 17)
        
        return CCUtility.getJSONfrom(dictionary: dict)
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
}
