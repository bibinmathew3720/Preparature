//
//  AddPlacesTableViewCell.swift
//  Preparture
//
//  Created by Nimmy K Das on 10/20/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

protocol AddPlacesTableViewCellDelegate {
    func closeAction(cell:AddPlacesTableViewCell, tag:Int)
}

class AddPlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    var delegate:AddPlacesTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionClose(_ sender: Any) {
        delegate?.closeAction(cell: self, tag: self.tag)
    }
}
