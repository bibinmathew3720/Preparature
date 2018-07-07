//
//  EditProfileViewController.swift
//  Preparture
//
//  Created by praveen raj on 07/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPlace: UILabel!
    
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    override func initView() {
        super.initView()

        customization()
    }

    func customization() {
        
    }

    @IBAction func actionEdit(_ sender: Any) {
    }
}
