//
//  HomeListTVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 7/5/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

protocol HomeListTVCDelegate {
    func addToFavorite(tag:NSInteger, favButton:UIButton)
    func shareAction(tag:NSInteger)
    func doubleArrowButtonAction(tag:NSInteger)
}

class HomeListTVC: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var conView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    var delegate:HomeListTVCDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        delegate?.addToFavorite(tag: self.tag, favButton: sender)
    }
    @IBAction func doubleArrowAction(_ sender: UIButton) {
        delegate?.doubleArrowButtonAction(tag: self.tag)
    }
    @IBAction func shareButtonAction(_ sender: UIButton) {
        delegate?.shareAction(tag: self.tag)
    }
    
    func eventItem(event:EventItem){
        self.headingLabel.text = event.name
        self.subHeadingLabel.text = event.location
        self.descriptionLabel.text = event.travelExperience
        self.ratingLabel.text = String(format: "%@.0", String(event.rating))
        if event.eventImages.count>0{
            if let eventImage = event.eventImages.first {
                itemImageView.sd_setImage(with: URL(string: eventImage), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
            }
        }
        favoriteButton.isSelected = event.isFavourite
        self.dateLabel.text = CCUtility.convertToDateToFormat(inputDate: event.eventDate, inputDateFormat: "yyyy-MM-dd HH:mm:ss", outputDateFormat: "MMM dd, yy")
    }
    
}
