//
//  SignUpViewController.swift
//  Preparture
//
//  Created by praveen raj on 24/06/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    
    override func initView() {
        super.initView()

        // Do any additional setup after loading the view.
    }
    @IBAction func actionCamera(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func actionSignup(_ sender: Any) {
        self.view.endEditing(true)
        if (self.isValidSignUpDetails()){
            callingSignUpApi()
        }
    }
    func callingSignUpApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().callingSignUpApi(with: getSignUpRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? SignUpResponseModel{
                if model.statusCode == 1{
                    CCUtility.showDefaultAlertwithCompletionHandler(_title: Constant.AppName, _message: "You have registered successfully", parentController: self, completion: { (status) in
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
    
    func getSignUpRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let name = self.tfName.text {
            dict.updateValue(name as AnyObject, forKey: "name")
        }
        if let uName = self.tfUserName.text {
            dict.updateValue(uName as AnyObject, forKey: "username")
        }
        if let email = self.tfEmail.text {
            dict.updateValue(email as AnyObject, forKey: "email")
        }
        if let password = self.tfPassword.text {
            dict.updateValue(password as AnyObject, forKey: "password")
        }
        dict.updateValue("imageurl" as AnyObject, forKey: "user_image")
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
    @IBAction func actioonBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func isValidSignUpDetails()->Bool{
        var valid = true
        var messageString = ""
        if (self.tfName.text?.isEmpty)!{
            messageString = "Please enter your name"
            valid = false
        }
        else if (self.tfUserName.text?.isEmpty)!{
            messageString = "Please enter your user name"
            valid = false
        }
        else if (self.tfEmail.text?.isEmpty)! {
            messageString = "Please enter email id"
            valid = false
        }
        else if !(self.tfEmail.text?.isValidEmail())! {
            messageString = "Please enter valid email id"
            valid = false
        }
        else if (self.tfPassword.text?.isEmpty)! {
            messageString = "Please enter password"
            valid = false
        }
        else if (self.tfConfirmPassword.text?.isEmpty)! {
            messageString = "Please enter confirm password"
            valid = false
        }
        else if (self.tfPassword.text != self.tfConfirmPassword.text) {
            messageString = "Password mismatch"
            valid = false
        }
        if !valid {
            CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: messageString, parentController: self)
        }
        return valid
    }
}

// MARK : -> ------ UITextField Delegates ------

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var message = String()
        guard let _text = textField.text else {
            return true
        }
        if textField == tfName {
            tfName.resignFirstResponder()
            tfUserName.becomeFirstResponder()
        } else if textField == tfUserName {
            tfUserName.resignFirstResponder()
            tfEmail.becomeFirstResponder()
        } else if textField == tfEmail {
            tfEmail.resignFirstResponder()
            tfPassword.becomeFirstResponder()
        } else if textField == tfPassword {
            tfPassword.resignFirstResponder()
            tfConfirmPassword.becomeFirstResponder()
        } else {
            tfConfirmPassword.resignFirstResponder()
        }
        return true
    }
    
}
