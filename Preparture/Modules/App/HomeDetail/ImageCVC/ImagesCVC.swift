//
//  ImagesCVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 8/3/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

protocol ImagesCVCDelegate {
    func closeButtonActionDelegate(tag:NSInteger)
}

class ImagesCVC: UICollectionViewCell {
    @IBOutlet weak var closeButtonHeightConsnt: NSLayoutConstraint!
    @IBOutlet weak var closeButtonWidthConstrnt: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var eventImageView: UIImageView!
    var imagesCVCDelegate:ImagesCVCDelegate?
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
        closeButton.isHidden = false
        closeButtonHeightConsnt.constant = 32
        closeButtonWidthConstrnt.constant = 32
        eventImageView.image = image
    }

    @IBAction func closeButtonAction(_ sender: UIButton) {
        imagesCVCDelegate?.closeButtonActionDelegate(tag: self.tag)
    }
}
