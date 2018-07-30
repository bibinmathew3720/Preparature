//
//  ChangePswdViewController.swift
//  Preparture
//
//  Created by praveen raj on 07/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class ChangePswdViewController: BaseViewController {

    @IBOutlet weak var tfCurrent: UITextField!
    @IBOutlet weak var tfNew: UITextField!
    @IBOutlet weak var tfConfirm: UITextField!
    override func initView() {
        super.initView()
        
        customization()
    }
    
    func customization() {
        
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        if (isValidChangePasswordInputs()){
            callingChangePasswordApi()
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func isValidChangePasswordInputs()->Bool{
        var valid = true
        var messageString = ""
        if (self.tfCurrent.text?.isEmpty)!{
            messageString = "Please enter your current password"
            valid = false
        }
        else if (self.tfNew.text?.isEmpty)!{
            messageString = "Please enter new password"
            valid = false
        }
        else if (self.tfConfirm.text?.isEmpty)! {
            messageString = "Please enter confirm password"
            valid = false
        }
        else if (self.tfNew.text != self.tfConfirm.text) {
            messageString = "Password mismatch"
            valid = false
        }
        if !valid {
            CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: messageString, parentController: self)
        }
        return valid
    }
    
    func callingChangePasswordApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().callingChangePasswordApi(with: getChangePasswordRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? ChangePasswordResponseModel{
                if model.statusCode == 1{
                    CCUtility.showDefaultAlertwithCompletionHandler(_title: Constant.AppName, _message: "You password changed successfully", parentController: self, completion: { (status) in
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
    
    func getChangePasswordRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let curPwd = self.tfCurrent.text {
            dict.updateValue(curPwd as AnyObject, forKey: "old_password")
        }
        if let newPwd = self.tfNew.text {
            dict.updateValue(newPwd as AnyObject, forKey: "new_password")
        }
        if let user = User.getUser() {
            dict.updateValue(user.userId as AnyObject, forKey: "user_id")
        }
        return CCUtility.getJSONfrom(dictionary: dict)
    }
}

// MARK : -> ------ UITextField Delegates ------

extension ChangePswdViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var message = String()
        guard let _text = textField.text else {
            return true
        }
        if textField == tfCurrent {
            tfCurrent.resignFirstResponder()
            tfNew.becomeFirstResponder()
        } else if textField == tfNew {
            tfNew.resignFirstResponder()
            tfConfirm.becomeFirstResponder()
        } else {
            tfConfirm.resignFirstResponder()
        }
        return true
    }
    
}
