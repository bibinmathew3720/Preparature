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
    @IBOutlet weak var categoryTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFavoriteitem(favorite:FavoriteItem){
        if favorite.placeImages.count>0{
            if let placeImage = favorite.placeImages.first {
                favoriteImageView.sd_setImage(with: URL(string: placeImage), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
            }
        }
        categoryLabel.text = favorite.placeType.uppercased()
        nameLabel.text = favorite.userName
        locationLabel.text = favorite.placeLocation
        categoryTypeLabel.text = favorite.placeName
    }
    
}
