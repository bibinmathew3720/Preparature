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
    @IBOutlet weak var starButton1: UIButton!
    @IBOutlet weak var starButton2: UIButton!
    @IBOutlet weak var starButton3: UIButton!
    @IBOutlet weak var starButton4: UIButton!
    @IBOutlet weak var starButton5: UIButton!
    @IBOutlet weak var labelReviewComments: UILabel!
    @IBOutlet weak var suggestionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(model:UserSuggestion) {
        labelReviewerName.text = model.userName
        labelReviewComments.text = model.comments
        imageReviewer.sd_setImage(with: URL(string: model.userProfImage), completed: nil)
        self.labelReviewerDate.text = CCUtility.convertToDateToFormat(inputDate: model.createdDate, inputDateFormat: "yyyy-MM-dd HH:mm:ss", outputDateFormat: "MMM dd, yyyy")
        if model.placeFiles.count>0{
            if let placeFile = model.placeFiles.first {
                suggestionImageView.sd_setImage(with: URL(string: placeFile), completed: nil)
            }
        }
        settingRating(rating: model.rating)
    }
    
    func settingRating(rating:Int){
        starButton1.isSelected = false
        starButton2.isSelected = false
        starButton3.isSelected = false
        starButton4.isSelected = false
        starButton5.isSelected = false
        if rating == 1 {
            starButton1.isSelected = true
        }
        else if (rating == 2){
            starButton1.isSelected = true
            starButton2.isSelected = true
        }
        else if (rating == 3){
            starButton1.isSelected = true
            starButton2.isSelected = true
            starButton3.isSelected = true
        }
        else if (rating == 4){
            starButton1.isSelected = true
            starButton2.isSelected = true
            starButton3.isSelected = true
            starButton4.isSelected = true
        }
        else if (rating == 5){
            starButton1.isSelected = true
            starButton2.isSelected = true
            starButton3.isSelected = true
            starButton4.isSelected = true
            starButton5.isSelected = true
        }
    }
}
