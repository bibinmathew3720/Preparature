//
//  SuggestionsTableViewCell.swift
//  Preparture
//
//  Created by praveen raj on 14/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit
import SDWebImage

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
    
    func setModel(model:SuggestionItem) {
        labelReviewerName.text = model.name
        labelReviewComments.text = model.comments
        imageReviewer.sd_setImage(with: URL(string: model.userImage), completed: nil)
        self.labelReviewerDate.text = CCUtility.convertToDateToFormat(inputDate: model.createdDate, inputDateFormat: "yyyy-MM-dd HH:mm:ss", outputDateFormat: "MMM yyyy")
        if model.rating == "0" {
            starReviewerFirst.image = #imageLiteral(resourceName: "starUnSelected")
            starReviewerSecond.image = #imageLiteral(resourceName: "starUnSelected")
            starReviewerThird.image = #imageLiteral(resourceName: "starUnSelected")
            starReviewerFourth.image = #imageLiteral(resourceName: "starUnSelected")
            starReviewerFifth.image = #imageLiteral(resourceName: "starUnSelected")
        } else if model.rating == "1" {
            starReviewerFirst.image = #imageLiteral(resourceName: "starSelected")
            starReviewerSecond.image = #imageLiteral(resourceName: "starUnSelected")
            starReviewerThird.image = #imageLiteral(resourceName: "starUnSelected")
            starReviewerFourth.image = #imageLiteral(resourceName: "starUnSelected")
            starReviewerFifth.image = #imageLiteral(resourceName: "starUnSelected")
        } else if model.rating == "2" {
            starReviewerFirst.image = #imageLiteral(resourceName: "starSelected")
            starReviewerSecond.image = #imageLiteral(resourceName: "starSelected")
            starReviewerThird.image = #imageLiteral(resourceName: "starUnSelected")
            starReviewerFourth.image = #imageLiteral(resourceName: "starUnSelected")
            starReviewerFifth.image = #imageLiteral(resourceName: "starUnSelected")
        } else if model.rating == "3" {
            starReviewerFirst.image = #imageLiteral(resourceName: "starSelected")
            starReviewerSecond.image = #imageLiteral(resourceName: "starSelected")
            starReviewerThird.image = #imageLiteral(resourceName: "starSelected")
            starReviewerFourth.image = #imageLiteral(resourceName: "starUnSelected")
            starReviewerFifth.image = #imageLiteral(resourceName: "starUnSelected")
        } else if model.rating == "4" {
            starReviewerFirst.image = #imageLiteral(resourceName: "starSelected")
            starReviewerSecond.image = #imageLiteral(resourceName: "starSelected")
            starReviewerThird.image = #imageLiteral(resourceName: "starSelected")
            starReviewerFourth.image = #imageLiteral(resourceName: "starSelected")
            starReviewerFifth.image = #imageLiteral(resourceName: "starUnSelected")
        } else if model.rating == "5" {
            starReviewerFirst.image = #imageLiteral(resourceName: "starSelected")
            starReviewerSecond.image = #imageLiteral(resourceName: "starSelected")
            starReviewerThird.image = #imageLiteral(resourceName: "starSelected")
            starReviewerFourth.image = #imageLiteral(resourceName: "starSelected")
            starReviewerFifth.image = #imageLiteral(resourceName: "starSelected")
        } else {
            
        }
    }
}
