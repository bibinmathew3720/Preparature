//
//  CLNetworkModel.swift
//  CCLUB
//
//  Created by Albin Joseph on 2/7/18.
//  Copyright © 2018 Albin Joseph. All rights reserved.
//

import UIKit

class CLNetworkModel: NSObject {
    var requestURL: String?
    var requestMethod: String?
    var requestBody: String?
    var requestHeader: [String : String]?
    init(url : String, requestMethod_ : String){
        requestURL = url
        requestMethod = requestMethod_
        requestHeader = [String : String]()
        _ = requestHeader?.updateValue("application/json", forKey: "Content-Type")
       // _ = requestHeader?.updateValue("application/json", forKey: "Content-Type")
//        let appController = CLAppController.sharedInstance
//        if let _cLTokenModel = appController.cLTokenModel{
//            _ = requestHeader?.updateValue(_cLTokenModel.tokenType + " " + _cLTokenModel.accessToken, forKey: "Authorization")
//        }
    }
}
