//
//  AdditineraryTVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 2/2/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit
enum TextFieldType{
    case textFieldLandmarkName
    case textFieldLatitude
    case textFieldLongitude
    case textFieldCheckIn
    case textFieldCheckOut
    case textFieldStartDate
    case textFieldEndDate
}

protocol AddItineraryTVCDelegate {
    func textFieldShouldBeginDelegate(textField:UITextField,type:TextFieldType,tag:Int)
    func textFieldEditeChangedDelegate(tag: Int, textField: UITextField, textFieldType:TextFieldType)
    func landMarkButtonActionDelegate(tag:Int)
}
class AdditineraryTVC: UITableViewCell {
    @IBOutlet weak var landMarkNameTF: UITextField!
    @IBOutlet weak var landmarkLatitudeTF: UITextField!
    @IBOutlet weak var landmarkLongitudeTF: UITextField!
    @IBOutlet weak var checkInTF: UITextField!
    @IBOutlet weak var checkOutTF: UITextField!
    var textFieldType = TextFieldType.textFieldCheckIn
    
    var delegate:AddItineraryTVCDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        initialisation()
        // Initialization code
    }
    
    func initialisation(){
        self.layer.cornerRadius = 5
        self.layer.borderColor = Constant.Colors.AppCommonGreyColor.cgColor
        self.layer.borderWidth = 1
        landMarkNameTF.delegate = self
        landmarkLatitudeTF.delegate = self
        landmarkLongitudeTF.delegate = self
        checkInTF.delegate = self
        checkOutTF.delegate = self
    }
    
    @IBAction func landMarkNameButtonAction(_ sender: UIButton) {
        if let _del = delegate{
            _del.landMarkButtonActionDelegate(tag: self.tag)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLandMarkDetails(landMark:AddLandmark){
        landMarkNameTF.text = landMark.landmarkName
        landmarkLatitudeTF.text = "\(landMark.landmarkLatitude)"
        landmarkLongitudeTF.text = "\(landMark.landmarkLongitude)"
        checkInTF.text = landMark.checkInDate
        checkOutTF.text = landMark.checkOutDate
    }
    
    @IBAction func textFieldEditingChnaged(_ sender: UITextField) {
        if let del = delegate{
            del.textFieldEditeChangedDelegate(tag: self.tag, textField: sender, textFieldType:self.textFieldType)
        }
    }
}

extension AdditineraryTVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == landMarkNameTF{
           textFieldType = .textFieldLandmarkName
        }
        else if textField == landmarkLatitudeTF{
            textFieldType = .textFieldLatitude
        }
        else if textField == landmarkLongitudeTF{
            textFieldType = .textFieldLongitude
        }
        else if textField == checkInTF{
            textFieldType = .textFieldCheckIn
        }
        else if textField == checkOutTF{
            textFieldType = .textFieldCheckOut
        }
        if let del = delegate{
            del.textFieldShouldBeginDelegate(textField: textField, type: textFieldType, tag: self.tag)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == landMarkNameTF{
            landmarkLatitudeTF.becomeFirstResponder()
        }
        else if textField == landmarkLatitudeTF{
            landmarkLongitudeTF.becomeFirstResponder()
        }
        else if textField == landmarkLongitudeTF{
            checkInTF.becomeFirstResponder()
        }
        return true
    }
}

