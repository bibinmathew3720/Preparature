//
//  EventsTVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 5/30/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit

class EventsTVC: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addCardShadow()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func eventItem(event:EventItem){
//        self.headingLabel.text = event.name
//        self.subHeadingLabel.text = event.location
//        self.descriptionLabel.text = event.travelExperience
//        self.ratingLabel.text = String(format: "%@.0", String(event.rating))
//        if event.eventImages.count>0{
//            if let eventImage = event.eventImages.first {
//                itemImageView.sd_setImage(with: URL(string: eventImage), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
//            }
//        }
//        favoriteButton.isSelected = event.isFavourite
//        self.dateLabel.text = CCUtility.convertToDateToFormat(inputDate: event.eventDate, inputDateFormat: "yyyy-MM-dd HH:mm:ss", outputDateFormat: "MMM dd, yy")
    }
    
}
