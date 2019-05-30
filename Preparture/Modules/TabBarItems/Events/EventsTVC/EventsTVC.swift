//
//  EventsTVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 5/30/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit

class EventsTVC: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addCardShadow()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
