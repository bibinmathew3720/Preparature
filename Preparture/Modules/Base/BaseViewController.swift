//
//  BaseViewController.swift
//  Preparture
//
//  Created by praveen raj on 17/06/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {
        
    }
    
    //MARK: Adding Shadow View
    
    func addShadowToAView(shadowView:UIView){
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 3
    }
    
    //MARK:- Add To Favorite Api integration
    
    func callingAddToFavoriteApi(suggestionItem:EventItem, success : @escaping (Bool)->()){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().addToFavoriteApi(with: addToFavoriteRequestBody(suggestion:suggestionItem), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AddToFavoriteResponseModel{
                if model.statusCode == 1{
                     CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: "The event has been added to your favourites", parentController: self)
                    success (true)
                    
                }
                else{
                    CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.statusMessage, parentController: self)
                     success (false)
                }
            }
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            } else {
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
            success (false)
            print(ErrorType)
        }
    }
    
    func addToFavoriteRequestBody(suggestion:EventItem)->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let user = User.getUser() {
            dict.updateValue(user.userId as AnyObject, forKey: "user_id")
        }
        dict.updateValue(suggestion.eventId as AnyObject, forKey: "event_id")
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
    //MARK:- Remove from Favorite Api integration
    
    func callingRemoveFromFavoriteApi(suggestionItem:EventItem, success : @escaping (Bool)->()){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().removeFromFavoriteApi(with: reoveFromFavoriteRequestBody(suggestion:suggestionItem), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AddToFavoriteResponseModel{
                if model.statusCode == 1{
                     CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: "The event removed from your favourites", parentController: self)
                    success (true)
                }
                else{
                    CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.statusMessage, parentController: self)
                    success (false)
                }
            }
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            } else {
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
            success (false)
            print(ErrorType)
        }
    }
    
    func reoveFromFavoriteRequestBody(suggestion:EventItem)->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let user = User.getUser() {
            dict.updateValue(user.userId as AnyObject, forKey: "user_id")
        }
        dict.updateValue(suggestion.eventId as AnyObject, forKey: "event_id")
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
    //MARK:- Get All Categories Api integration
    
    func getAllCategoryApi(success : @escaping (Bool,GetAllCategoryResponseModel?)->()){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().getCategoryApi(with: "", success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? GetAllCategoryResponseModel{
                success(true,model)
            }
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            success(false,nil)
            if(ErrorType == .noNetwork){
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            } else {
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
            print(ErrorType)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
