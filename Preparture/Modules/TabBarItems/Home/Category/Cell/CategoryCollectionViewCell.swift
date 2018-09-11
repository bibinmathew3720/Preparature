//
//  CategoryCollectionViewCell.swift
//  Preparture
//
//  Created by Nimmy K Das on 9/8/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCategoryArray(categoryItem:CategoryItem){
        let urlString = categoryItem.categoryIcon.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        imageIcon.sd_setImage(with: URL(string: urlString!), placeholderImage: UIImage(named: ""))
        labelCategory.text = categoryItem.categoryName
    }
}
