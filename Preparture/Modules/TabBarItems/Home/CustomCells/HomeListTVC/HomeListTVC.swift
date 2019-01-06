//
//  HomeListTVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 7/5/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

protocol HomeListTVCDelegate {
    func addToFavorite(tag:NSInteger)
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
        delegate?.addToFavorite(tag: self.tag)
    }
    @IBAction func doubleArrowAction(_ sender: UIButton) {
        delegate?.doubleArrowButtonAction(tag: self.tag)
    }
    @IBAction func shareButtonAction(_ sender: UIButton) {
        delegate?.shareAction(tag: self.tag)
    }
    
    func setSuggestionItem(suggestion:EventItem){
       // self.headingLabel.text = suggestion.authorName
        self.subHeadingLabel.text = suggestion.placeName
        self.descriptionLabel.text = suggestion.location
        self.ratingLabel.text = String(suggestion.rating)
        if suggestion.placeImages.count>0{
            if let placeImage = suggestion.placeImages.first {
                itemImageView.sd_setImage(with: URL(string: placeImage), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
            }
        }
        //favoriteButton.isSelected = suggestion.isFavorited
        self.dateLabel.text = CCUtility.convertToDateToFormat(inputDate: suggestion.createdDate, inputDateFormat: "yyyy-MM-dd HH:mm:ss", outputDateFormat: "dd/MM/yyyy")
    }
    
}
