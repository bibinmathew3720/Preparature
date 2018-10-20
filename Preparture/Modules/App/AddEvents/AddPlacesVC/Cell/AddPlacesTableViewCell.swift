//
//  AddPlacesTableViewCell.swift
//  Preparture
//
//  Created by Nimmy K Das on 10/20/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

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
    
    func setModel(model: Any) {
        if let value = model as? GMSPlace {
            labelName.text = value.name
        }
        if let value = model as? GMSMarker {
            labelName.text = value.title
        }
    }
    
    @IBAction func actionClose(_ sender: Any) {
        delegate?.closeAction(cell: self, tag: self.tag)
    }
}
