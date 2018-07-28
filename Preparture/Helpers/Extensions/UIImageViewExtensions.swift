//
//  UIImageViewExtensions.swift
//  CCLUB
//
//  Created by Albin Joseph on 3/13/18.
//  Copyright © 2018 Albin Joseph. All rights reserved.
//

import UIKit
import Foundation

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        if urlString.isEmpty{
            print("---------------------EMPTY EMPTY----------------")
        }else{
            let url = URL(string: urlString)
            self.image = nil
            
            // check cached image
            if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
                self.image = cachedImage
                return
            }
            
            // if not, download image from url
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data!) {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self.image = image
                    }
                }
                
            }).resume()
        }
        
    }
}
