//
//  Constants.swift
//  Preparture
//
//  Created by praveen raj on 18/06/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import Foundation

let APPNAME = "Trippinyea"

struct Constant{
    static let AppName = "Trippinyea"
    struct Colors{
        static let AppThemeGreenColor = UIColor(red:0.60, green:0.79, blue:0.23, alpha:1.0) //99CA3B
    }
    struct ImageNames{
        struct  tabImages {
            static let homeTabIcon = "homeTab"
            static let homeTabSelected = "homeTabSelected"
            static let favoriteTabIcon = "favoritesTab"
            static let favoritesTabSelected = "favoritesTabSelected"
            static let settingsIcon = "settings"
            static let settingsTabSelected = "settingsTabSelected"
        }
    }
    
    struct Titles{
        static let homeTitle = "Home"
        static let favoritesTitle = "Favorite"
        static let settingsTitle = "Settings"
    }
}
