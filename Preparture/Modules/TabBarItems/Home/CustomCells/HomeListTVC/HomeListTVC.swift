//
//  HomeListTVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 7/5/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class HomeListTVC: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var conView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
    }
    @IBAction func doubleArrowAction(_ sender: UIButton) {
    }
    @IBAction func shareButtonAction(_ sender: UIButton) {
    }
    
    func setSuggestionItem(suggestion:SuggestionItems){
        self.headingLabel.text = suggestion.userName
        self.subHeadingLabel.text = suggestion.placeName
        self.descriptionLabel.text = suggestion.placeLocation
        self.ratingLabel.text = String(suggestion.rating)
        if suggestion.placeImages.count>0{
            if let placeImage = suggestion.placeImages.first {
                itemImageView.sd_setImage(with: URL(string: placeImage), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
            }
        }
        self.dateLabel.text = CCUtility.convertToDateToFormat(inputDate: suggestion.createdDate, inputDateFormat: "yyyy-MM-dd HH:mm:ss", outputDateFormat: "dd/MM/yyyy")
    }
    
}
