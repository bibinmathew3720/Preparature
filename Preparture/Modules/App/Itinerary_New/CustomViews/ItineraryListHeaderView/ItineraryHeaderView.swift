//
//  ItineraryHeaderView.swift
//  Preparture
//
//  Created by Bibin Mathew on 1/27/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit
protocol ItineraryHeaderViewDelegate {
    func openButtonActionDelegate(button:UIButton)
}
class ItineraryHeaderView: UIView {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var openCloseButton: UIButton!
    var delegate:ItineraryHeaderViewDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialisation()
    }
    
    func initialisation(){
        //headerView.layer.cornerRadius = 5
        headerView.layer.borderColor = Constant.Colors.AppCommonGreyColor.cgColor
        headerView.layer.borderWidth = 1
    }

    @IBAction func openCloseButtonAction(_ sender: UIButton) {
        if let del = delegate{
            del.openButtonActionDelegate(button: sender)
        }
    }
    
    func setItineraryDetails(itineraryDetails:ItineraryDetails){
        nameLabel.text = itineraryDetails.itineraryName
        arrivalDateLabel.text = CCUtility.convertToDateToFormat(inputDate: itineraryDetails.startDate, inputDateFormat: "dd/MM/yyyy HH:mm a", outputDateFormat: "MMM dd, yy hh:mm a")
        departureDateLabel.text = CCUtility.convertToDateToFormat(inputDate: itineraryDetails.endDate, inputDateFormat: "dd/MM/yyyy hh:mm a", outputDateFormat: "MMM dd, yy hh:mm a")
    }
}
