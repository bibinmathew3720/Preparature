//
//  ImagesCVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 8/3/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class ImagesCVC: UICollectionViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setImageUrlString(imageUrlString:String){
        eventImageView.sd_setImage(with: URL(string: imageUrlString), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
    }
    
    func setImageUrl(imageUrlString:URL){
        eventImageView.sd_setImage(with: imageUrlString, placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
    }
    
    func setImage(image:UIImage){
        eventImageView.image = image
    }

}
