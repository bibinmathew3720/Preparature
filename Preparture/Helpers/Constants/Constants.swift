//
//  Constants.swift
//  Preparture
//
//  Created by praveen raj on 18/06/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import Foundation

struct Constant{
    static let AppName = "Trippinyea"
    struct UserDefaultskeys {
        static let isLoggedIn = "isLoggedIn"
    }
    struct Colors{
        static let AppThemeGreenColor = UIColor(red:0.60, green:0.79, blue:0.23, alpha:1.0) //99CA3B
        static let AppThemeYellowColor = UIColor(red:0.91, green:0.70, blue:0.05, alpha:1.0) //e9b30d
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
        static let HomeTitle = "Home"
        static let FavoritesTitle = "Favorite"
        static let SettingsTitle = "Settings"
    }
    
    struct ErrorMessages{
        static let noNetworkMessage = "Network not available"
        static let serverErrorMessamge = "Unable to connect server"
    }
}
