//
//  ItineraryListTVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 1/27/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit

class ItineraryListTVC: UITableViewCell {
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var landmarkNameLabel: UILabel!
    @IBOutlet weak var checkInTimeLabel: UILabel!
    @IBOutlet weak var checkOutTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        initialisation()
        // Initialization code
    }
    
    func initialisation(){
       // borderView.layer.cornerRadius = 5
        borderView.layer.borderColor = Constant.Colors.AppCommonGreyColor.cgColor
        borderView.layer.borderWidth = 1
    }
    
    func setLandMarkDetails(landMarkDetails:LandMarkDetails){
        landmarkNameLabel.text = landMarkDetails.landMarkName
        checkInTimeLabel.text = landMarkDetails.checkIn
        checkOutTimeLabel.text = landMarkDetails.checkOut
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func directionButtonAction(_ sender: UIButton) {
    }
}
