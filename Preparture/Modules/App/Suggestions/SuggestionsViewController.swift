//
//  SuggestionsViewController.swift
//  Preparture
//
//  Created by praveen raj on 07/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class SuggestionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    @IBOutlet weak var tableviewReviews: UITableView!
    @IBOutlet weak var tfType: UITextField!
    @IBOutlet weak var textViewSuggestions: UITextView!
    @IBOutlet var pickerViewType: UIPickerView!
    @IBOutlet var toolBarPicker: UIToolbar!
    @IBOutlet weak var buttonStarFirst: UIButton!
    var pickerArray = ["Hotels", "Hospitals", "Restaurants"]
    var selectedIndex:NSInteger = 0
    @IBOutlet weak var buttonStarSecond: UIButton!
    @IBOutlet weak var buttonStarThird: UIButton!
    @IBOutlet weak var buttonStarForth: UIButton!
    @IBOutlet weak var buttonStarFifth: UIButton!
    
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
    
    //MARK: -> ------ UITextView Delegates ------
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var frame = textView.frame
        frame.size.height = textView.contentSize.height
        if frame.size.height > 70 {
            frame.size.height = 70
            frame.origin.y = 5
        } else {
            frame.origin.y = 25
        }
        textView.frame = frame
        if(text == "\n") {
            textView.resignFirstResponder()
            if textView.text.count == 0 {
                textView.text = "Write your suggestions"
            }
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write your suggestions" {
            textView.text = ""
        }
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionAddIMage(_ sender: Any) {
    }
    
    @IBAction func actionStarFirst(_ sender: Any) {
        selectStarRate(isFirst: true, isSecond: false, isThird: false, isForth: false, isFifth: false)
    }
    
    @IBAction func actionStarSecond(_ sender: Any) {
        selectStarRate(isFirst: true, isSecond: true, isThird: false, isForth: false, isFifth: false)
    }
    
    @IBAction func actionStarThird(_ sender: Any) {
        selectStarRate(isFirst: true, isSecond: true, isThird: true, isForth: false, isFifth: false)
    }
    
    @IBAction func actionStarFourth(_ sender: Any) {
        selectStarRate(isFirst: true, isSecond: true, isThird: true, isForth: true, isFifth: false)
    }
    
    @IBAction func actionStarFifth(_ sender: Any) {
        selectStarRate(isFirst: true, isSecond: true, isThird: true, isForth: true, isFifth: true)
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
    }
    
    @IBAction func actionToolbarDone(_ sender: Any) {
        guard let code:String = pickerArray[selectedIndex] else {
            return
        }
        tfType.text = code
        tfType.resignFirstResponder()
    }
    
    @IBAction func actionToolbarCancel(_ sender: Any) {
        tfType.resignFirstResponder()
    }
    
    //MARK:- Rate Selection
    
    func selectStarRate(isFirst: Bool, isSecond: Bool, isThird: Bool, isForth: Bool, isFifth: Bool) {
        buttonStarFirst.isSelected = isFirst
        buttonStarSecond.isSelected = isSecond
        buttonStarThird.isSelected = isThird
        buttonStarForth.isSelected = isForth
        buttonStarFifth.isSelected = isFifth
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
