//
//  ForgotPasswordViewController.swift
//  Preparture
//
//  Created by praveen raj on 24/06/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var tfEmail: UITextField!
    
    override func initView() {
        super.initView()
        
        // Do any additional setup after loading the view.
    }

    //MARK: - UIView Action Methods
    
    @IBAction func actionContinue(_ sender: Any) {
        if isValidInputDetails(){
            callingForgotPasswordApi()
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func isValidInputDetails()->Bool{
        var valid = true
        var messageString = ""
        if (self.tfEmail.text?.isEmpty)! {
            messageString = "Please enter email id"
            valid = false
        }
        else if !(self.tfEmail.text?.isValidEmail())! {
            messageString = "Please enter valid email id"
            valid = false
        }
        if !valid {
            CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: messageString, parentController: self)
        }
        return valid
    }
    
    func callingForgotPasswordApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().callingForgotPasswordApi(with: getForgotRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? ForgotResponseModel{
                if model.statusCode == 1{
                    CCUtility.showDefaultAlertwithCompletionHandler(_title: Constant.AppName, _message: model.statusMessage, parentController: self, completion: { (status) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                }
                else{
                    CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.statusMessage, parentController: self)
                }
                
            }
            
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
            
            print(ErrorType)
        }
    }
    
    func getForgotRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let email = self.tfEmail.text {
            dict.updateValue(email as AnyObject, forKey: "email")
        }
        return CCUtility.getJSONfrom(dictionary: dict)
    }
}

// MARK : -> ------ UITextField Delegates ------

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfEmail {
            tfEmail.resignFirstResponder()
        }
        return true
    }
}
