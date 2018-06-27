//
//  CLNetworkUtility.swift
//  CCLUB
//
//  Created by Albin Joseph on 2/7/18.
//  Copyright © 2018 Albin Joseph. All rights reserved.
//

import UIKit

class CLNetworkUtility: Reachability {
    
    private static var __once: () = {
        Static.instance = CLNetworkUtility(hostName: "www.google.com")
    }()
    
    
    
    struct Static {
        static var onceToken : Int = 0
        static var instance : CLNetworkUtility? = nil
    }
    
    class var sharedInstance : CLNetworkUtility {
        _ = CLNetworkUtility.__once
        return Static.instance!
    }
    
    
    
    
    func isConnected() -> Bool {
        
        let netStatus = self.currentReachabilityStatus()
        var isConnected = false
        
        switch netStatus.rawValue {
        case NotReachable.rawValue:
            isConnected = false
            
        case ReachableViaWiFi.rawValue:
            isConnected = true
            
        case ReachableViaWWAN.rawValue:
            isConnected = true
            
        default:
            isConnected = false
            
        }
        
        return isConnected
    }

}
