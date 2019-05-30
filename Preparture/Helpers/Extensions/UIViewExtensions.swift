//
//  UIViewExtensions.swift
//  Baiger
//
//  Created by Albin Joseph on 12/30/17.
//  Copyright © 2017 Albin Joseph. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    func addShadowToControls() {
        self.layer.shadowColor = UIColor(red:0.54, green:0.61, blue:0.90, alpha:1.0).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 8.0
        layer.masksToBounds = false
    }
    
    func addCardShadow()
    {
        self.layer.cornerRadius = 7.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.4
        
    }
        
}
