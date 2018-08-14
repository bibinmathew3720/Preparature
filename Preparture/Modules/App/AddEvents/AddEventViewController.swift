//
//  AddEventViewController.swift
//  Preparture
//
//  Created by praveen raj on 07/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class AddEventViewController: BaseViewController {

    @IBOutlet weak var tfType: UITextField!
    @IBOutlet var pickerViewType: UIPickerView!
    @IBOutlet var toolBarPicker: UIToolbar!
    var pickerArray = ["Hotels", "Hospitals", "Restaurants"]
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
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
    
    //MARK:- UIView Action Methods
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func actionStarFirst(_ sender: Any) {
    }
    
    @IBAction func actionStarSecond(_ sender: Any) {
    }
    
    @IBAction func actionStarThird(_ sender: Any) {
    }
    
    @IBAction func actionStarFourth(_ sender: Any) {
    }
    
    @IBAction func actionStarFifth(_ sender: Any) {
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
    }
    
    @IBAction func actionToolbarDone(_ sender: Any) {
        guard let code:String = pickerArray[selectedIndex] else {
            return
        }
        tfType.text = code
    }
    
    @IBAction func actionToolbarCancel(_ sender: Any) {
    }
    
    @IBAction func actionAddPlaces(_ sender: Any) {
        let vc:AddPlacesViewController = AddPlacesViewController(nibName: "AddPlacesViewController", bundle: nil)
        self.navigationController?.pushViewController(vc , animated: true)
    }
}
