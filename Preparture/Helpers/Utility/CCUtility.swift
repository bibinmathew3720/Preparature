//
//  CCUtility.swift
//  CCLUB
//
//  Created by Albin Joseph on 2/7/18.
//  Copyright © 2018 Albin Joseph. All rights reserved.
//

import UIKit

class CCUtility: NSObject {
    class func getJSONfrom(dictionary:[String:Any?]) -> String {
        var jsonString:String?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            
            jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
        } catch {
            print(error.localizedDescription)
        }
        guard let requestBody = jsonString else {
            return ""
        }
        return requestBody
    }
    
    
    class func showDefaultAlertwith(_title : String, _message : String, parentController : UIViewController){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")

            case .cancel:
                print("cancel")

            case .destructive:
                print("destructive")
            }
        }))
        parentController.present(alert, animated: true, completion: nil)
    }
    
   
    
    class func showDefaultAlertwithCompletionHandler(_title : String, _message : String, parentController : UIViewController, completion:@escaping (_ okSuccess:Bool)->()){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completion(true)
            switch action.style{
                
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        parentController.present(alert, animated: true, completion: nil)
    }
    
    class func showActionAlertwithCancel(_title : String, _message : String, parentController : UIViewController,action:UIAlertAction){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { action in
            //  alert.dismiss(animated: true, completion: )
        }))
        parentController.present(alert, animated: true, completion: nil)
        
    }
    
   class func showAlertWithOkOrCancel(_title : String, viewController:UIViewController, messageString:String, completion:@escaping (_ result:String) -> Void) {
    
        let alertController = UIAlertController(title: _title, message: messageString, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            completion ("Ok")
        }
        let noAction = UIAlertAction(title: "CANCEL", style: .default) { (action:UIAlertAction) in
            completion ("Cancel")
        }
   
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        viewController.present(alertController, animated: true) {
        }
    }
    class func showAlertWithoutOkOrCancel(_title : String, viewController:UIViewController, messageString:String, completion:@escaping () -> Void) {
        let alertController = UIAlertController(title: _title, message: messageString, preferredStyle: .alert)
        viewController.present(alertController, animated: true) {
        }
    }
    
    class func showActionAlertwith(_title : String, _message : String, parentController : UIViewController,action:UIAlertAction){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(action)
        parentController.present(alert, animated: true, completion: nil)
        
    }
    
    class func openSocialLink(_url : String){
        if let url = URL(string: _url) {
            if #available(iOS 10, *){
                UIApplication.shared.open(url)
            }else{
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    
    
    
    
    class func stringFromDate(date : Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd hh:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func stringFromDateWithYear(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, dd yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func stringFromDateOnlyYear(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func stringFromDateAndTime(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func dateString(with dateString : String,from dateFormat:String, to format:String) -> String
    {
        
        if dateString == "0000-00-00" || dateString == ""
        {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = format
        let dateStr = dateFormatter.string(from:date!)
        return dateStr
    }
    
    class func date(from dateString : String, to format:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") //Current time zone
        let date = dateFormatter.date(from: dateString)
        guard let _date = date else {
            return Date()
        }
        return _date
    }
    
    class func convertToDateToFormat(inputDate:String,inputDateFormat:String,outputDateFormat:String)->String{
        let inputFormatter = DateFormatter()
        inputFormatter.timeZone = NSTimeZone.local
        inputFormatter.dateFormat = inputDateFormat
        let showDate = inputFormatter.date(from: inputDate)
        inputFormatter.dateFormat = outputDateFormat
        var resultString = ""
        if let shDate = showDate {
            resultString = inputFormatter.string(from: shDate)
        }
        return resultString
        
    }
    
    class func processAfterLogIn(){
        UserDefaults.standard.set(true, forKey: Constant.UserDefaultskeys.isLoggedIn)
        NotificationCenter.default.post(name: .rootResettingNot, object: nil)
    }
    
   
    
    class func processAfterLogOut(){
        UserDefaults.standard.set(false, forKey: Constant.UserDefaultskeys.isLoggedIn)
        NotificationCenter.default.post(name: .rootResettingNot, object: nil)
        if let user = User.getUser(){
            User.deleteUser()
        }
    }
}
