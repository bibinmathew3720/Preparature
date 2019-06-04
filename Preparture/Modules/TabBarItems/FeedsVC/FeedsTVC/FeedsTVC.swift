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
        feedsImageView.sd_setImage(with: URL(string: feed.feedLink), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
        headingLabel.text = feed.feedTitle
        dateLabel.text = feed.feedDate
        print(feed.feedDescription)
    }
    
}
