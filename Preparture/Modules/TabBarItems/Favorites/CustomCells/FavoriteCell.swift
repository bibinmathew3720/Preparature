//
//  FavoriteCell.swift
//  Preparture
//
//  Created by Bibin Mathew on 7/6/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFavoriteitem(favorite:FavoriteItem){
        nameLabel.text = favorite.name
        locationLabel.text = favorite.location
        dateLabel.text = favorite.eventDate
        priceLabel.text = favorite.eventCost
        ratingLabel.text = String(format: "%d", favorite.rating)
        if favorite.eventImages.count>0{
            if let eventImage = favorite.eventImages.first {
                favoriteImageView.sd_setImage(with: URL(string: eventImage), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
            }
        }
        setRatingStar(rating: favorite.rating)
        //categoryLabel.text = favorite.placeType.uppercased()
    }
    
    func setRatingStar(rating:Int){
        self.star1Button.isSelected = false
        self.star2Button.isSelected = false
        self.star3Button.isSelected = false
        self.star4Button.isSelected = false
        self.star5Button.isSelected = false
        if (rating == 1){
            self.star1Button.isSelected = true
        }
        else if (rating == 2){
            self.star1Button.isSelected = true
            self.star2Button.isSelected = true
        }
        else if (rating == 3){
            self.star1Button.isSelected = true
            self.star2Button.isSelected = true
            self.star3Button.isSelected = true
        }
        else if (rating == 4){
            self.star1Button.isSelected = true
            self.star2Button.isSelected = true
            self.star3Button.isSelected = true
            self.star4Button.isSelected = true
        }
        else if (rating == 5){
            self.star1Button.isSelected = true
            self.star2Button.isSelected = true
            self.star3Button.isSelected = true
            self.star4Button.isSelected = true
            self.star5Button.isSelected = true
        }
    }
    
}
