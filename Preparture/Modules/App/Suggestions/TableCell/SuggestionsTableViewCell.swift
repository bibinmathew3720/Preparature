//
//  SuggestionsTableViewCell.swift
//  Preparture
//
//  Created by praveen raj on 14/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class SuggestionsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageReviewer: UIImageView!
    @IBOutlet weak var labelReviewerName: UILabel!
    @IBOutlet weak var labelReviewerDate: UILabel!
    @IBOutlet weak var starReviewerFirst: UIImageView!
    @IBOutlet weak var starReviewerSecond: UIImageView!
    @IBOutlet weak var starReviewerThird: UIImageView!
    @IBOutlet weak var starReviewerFourth: UIImageView!
    @IBOutlet weak var starReviewerFifth: UIImageView!
    @IBOutlet weak var labelReviewComments: UILabel!
    @IBOutlet weak var imageReview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
