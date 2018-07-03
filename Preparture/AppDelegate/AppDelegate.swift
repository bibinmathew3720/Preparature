//
//  AppDelegate.swift
//  Preparture
//
//  Created by praveen raj on 20/05/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        initialisingTabBar()
        return true
    }
    
    func initialisingTabBar(){
        let tabBarController = UITabBarController.init()
        
        let homeVC:HomeVC = HomeVC(nibName: "HomeVC", bundle: nil)
        let homeNavVC = UINavigationController.init(rootViewController: homeVC)
        homeVC.tabBarItem = settingTabBarItemFontsAndImages( selectedImageName: Constant.ImageNames.tabImages.homeTabSelected, unselectedImage: Constant.ImageNames.tabImages.homeTabIcon, title: Constant.Titles.homeTitle)
        
        let favoritesVC:FavoritesVC = FavoritesVC(nibName: "FavoritesVC", bundle: nil)
        let favoritesNavVC = UINavigationController.init(rootViewController: favoritesVC)
        favoritesVC.tabBarItem = settingTabBarItemFontsAndImages( selectedImageName: Constant.ImageNames.tabImages.favoritesTabSelected, unselectedImage: Constant.ImageNames.tabImages.favoriteTabIcon, title: Constant.Titles.favoritesTitle)
        
        let settingsVC:SettingsVC = SettingsVC(nibName: "SettingsVC", bundle: nil)
        let settingsNavVC = UINavigationController.init(rootViewController: settingsVC)
        settingsVC.tabBarItem = settingTabBarItemFontsAndImages( selectedImageName: Constant.ImageNames.tabImages.settingsTabSelected, unselectedImage: Constant.ImageNames.tabImages.settingsIcon, title: Constant.Titles.settingsTitle)
        
        tabBarController.viewControllers = [homeNavVC,favoritesNavVC,settingsNavVC];
        customisingTabBarController(tabBarCnlr: tabBarController)
        self.window?.rootViewController = tabBarController
    }
    
    func settingTabBarItemFontsAndImages(selectedImageName:String,unselectedImage:String,title:String)->UITabBarItem{
        let tabBarItem = UITabBarItem.init(title: title, image: UIImage.init(named: unselectedImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage.init(named: selectedImageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
        tabBarItem.imageInsets = UIEdgeInsets(top: -10, left: 0, bottom: 10, right: 0)
        return tabBarItem
    }
    
    func customisingTabBarController(tabBarCnlr:UITabBarController){
        UITabBar.appearance().backgroundImage = UIImage(named: "tabBarBG")
        let appearance = UITabBarItem.appearance()
        let attributes = [kCTFontAttributeName:UIFont(name: "Mada-Bold", size: 25)]
        appearance.setTitleTextAttributes([kCTForegroundColorAttributeName as NSAttributedStringKey: UIColor.white], for:.normal)
        appearance.setTitleTextAttributes([kCTForegroundColorAttributeName as NSAttributedStringKey: UIColor.white], for:.selected)
        //appearance.setTitleTextAttributes(attributes as [NSAttributedStringKey : Any], for: .normal)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
        UITabBar.appearance().contentMode = .scaleAspectFit
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

