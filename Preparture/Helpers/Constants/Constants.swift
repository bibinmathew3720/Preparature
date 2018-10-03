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
        static let placeholderImage = "placeHolder"
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
    struct ApiKey {
        static let googleMapKey = "AIzaSyDW3gXZCjFcNoBn3L2bA3nl6ZO6xw_EByw"
    }
    
    struct PhotoLibrary {
        static let actionFileTypeHeading = "Add a File"
        static let actionFileTypeDescription = "Choose a filetype to add..."
        static let camera = "Camera"
        static let phoneLibrary = "Phone Library"
        static let video = "Video"
        static let file = "File"
        
        
        static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
        
        static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
        
        static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
        
        
        static let settingsBtnTitle = "Settings"
        static let cancelBtnTitle = "Cancel"
        
    }
}
