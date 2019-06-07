//
//  FeedsTVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 6/4/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit

class FeedsTVC: UITableViewCell {
    @IBOutlet weak var feedsImageView: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFeed(feed:Feed){
        headingLabel.text = feed.feedTitle
        dateLabel.text = feed.feedDate
        loadfeedImageWithDescription(description:feed.feedDescription)
    }
    
    func loadfeedImageWithDescription(description:String){
        if (description.contains(".jpg")){
            self.processImageDescription(feedDesc:description,exten:".jpg")
        }
        else if (description.contains(".png")){
            self.processImageDescription(feedDesc:description,exten:".png")
        }
    }
    
func processImageDescription(feedDesc:String, exten:String){
    let descArray = feedDesc.components(separatedBy: "<img src=")
    if descArray.count > 0{
        let imageUrlArray = descArray.last?.components(separatedBy: exten)
        if let _imageUrlArray = imageUrlArray{
            if _imageUrlArray.count > 0{
                let imageurlString = _imageUrlArray.first
                if var _imageUrlString = imageurlString{
                    _imageUrlString = _imageUrlString.replacingOccurrences(of: "\\", with: "")
                    _imageUrlString = _imageUrlString.replacingOccurrences(of: "\"", with: "")
                    _imageUrlString = _imageUrlString + exten
                    guard let encodedUrlstring = _imageUrlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
                    feedsImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
                }
            }
        }
    }
}
    
}
