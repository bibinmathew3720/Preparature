//
//  AdditineraryTVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 2/2/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit

protocol AddItineraryTVCDelegate {
    func textFieldEditeChangedDelegate(tag:Int, textField:UITextField)
}
class AdditineraryTVC: UITableViewCell {
    @IBOutlet weak var landMarkNameTF: UITextField!
    @IBOutlet weak var landmarkLatitudeTF: UITextField!
    @IBOutlet weak var landmarkLongitudeTF: UITextField!
    @IBOutlet weak var checkInTF: UITextField!
    @IBOutlet weak var checkOutTF: UITextField!
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLandMarkDetails(landMark:AddLandmark){
        landMarkNameTF.text = landMark.landmarkName
        landmarkLatitudeTF.text = landMark.landmarkLatitude
        landmarkLongitudeTF.text = landMark.landmarkLongitude
        checkInTF.text = landMark.checkInDate
        checkOutTF.text = landMark.checkOutDate
    }
    
    @IBAction func textFieldEditingChnaged(_ sender: UITextField) {
        if let del = delegate{
            del.textFieldEditeChangedDelegate(tag: self.tag, textField: sender)
        }
    }
    
}
