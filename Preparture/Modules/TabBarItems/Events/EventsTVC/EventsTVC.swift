//
//  EventsTVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 5/30/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit
protocol EventsTVCDelegate{
    func favoriteButtonActionDelegate(tag:Int, favButton:UIButton)
    func itineraryButonActionDelegate(tag:Int)
    func shareButtonActionDelegate(tag:Int)
}
class EventsTVC: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var delegate:EventsTVCDelegate?
    
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
        if event.eventImages.count>0{
            if let eventImage = event.eventImages.first {
                eventImageView.sd_setImage(with: URL(string: eventImage), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
            }
        }
        self.ratingLabel.text = String(format: "%@.0", String(event.rating))
        self.ownerNameLabel.text = event.eventOwnerName
        self.dateLabel.text = CCUtility.convertToDateToFormat(inputDate: event.eventDate, inputDateFormat: "yyyy-MM-dd HH:mm:ss", outputDateFormat: "MMM dd, yy")
        self.eventNameLabel.text = event.name
        self.commentLabel.text = event.comments
        favoriteButton.isSelected = event.isFavourite
    }
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        if let _delegate = delegate{
            _delegate.favoriteButtonActionDelegate(tag: self.tag, favButton: sender)
        }
    }
    
    @IBAction func itineraryButtonAction(_ sender: UIButton) {
        if let _delegate = delegate{
            _delegate.itineraryButonActionDelegate(tag: self.tag)
        }
    }
    @IBAction func shareButtonAction(_ sender: UIButton) {
        if let _delegate = delegate{
            _delegate.shareButtonActionDelegate(tag: self.tag)
        }
    }
}
