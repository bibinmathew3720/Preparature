//
//  SuggestionsViewController.swift
//  Preparture
//
//  Created by praveen raj on 07/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class SuggestionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tableviewReviews: UITableView!
    @IBOutlet weak var tfType: UITextField!
    @IBOutlet weak var textViewSuggestions: UITextView!
    @IBOutlet var pickerViewType: UIPickerView!
    @IBOutlet var toolBarPicker: UIToolbar!
    var pickerArray = ["Hotels", "Hospitals", "Restaurants"]
    var selectedIndex:NSInteger = 0
    
    override func initView() {
        super.initView()
        
        customization()
    }
    
    func customization() {
        tableCellRegistration()
        tfType.inputView = pickerViewType
        tfType.inputAccessoryView = toolBarPicker
        pickerViewType.translatesAutoresizingMaskIntoConstraints = false
        toolBarPicker.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    @IBAction func actionAddIMage(_ sender: Any) {
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
    
    //MARK:- UITableViewCell Registration
    
    func tableCellRegistration(){
        tableviewReviews.register(UINib.init(nibName: "SuggestionsTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSuggestions")
    }
    
    //MARK:- UITableView Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSuggestions", for: indexPath) as! SuggestionsTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
}
