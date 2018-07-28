//
//  SignInViewController.swift
//  Preparture
//
//  Created by praveen raj on 17/06/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var labelSignup: UILabel!
    
    override func initView() {
        super.initView()

        customization()
    }

    func customization() {
        let myString:NSString = "Don't have an account? Sign Up"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Muli-Bold", size: 16)!])
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red:0.91, green:0.70, blue:0.05, alpha:1.0), range: NSRange(location:23,length:7))
        labelSignup.attributedText = myMutableString
        labelSignup.isUserInteractionEnabled = true
        labelSignup.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
    }

    //MARK:- Action methods
    
    @objc func handleTapOnLabel(_ recognizer: UITapGestureRecognizer) {
        // var range:NSRange  = NSRange(location:13,length:6)
        guard let text = labelSignup.attributedText?.string else {
            return
        }
        
        if let range = text.range(of: "Sign Up"),
            recognizer.didTapAttributedTextInLabel(label: labelSignup, inRange: NSRange(range, in: text))  {
            let signUpVc:SignUpViewController = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
            self.present(signUpVc, animated: true, completion: nil)
        }
    }
    
    @IBAction func actionFacebookLogin(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func actionGooglePlusLogin(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func actionForgotPassword(_ sender: Any) {
        self.view.endEditing(true)
        let fpVc:ForgotPasswordViewController = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
        self.present(fpVc, animated: true, completion: nil)
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        if isValidLogInDetails(){
            self.view.endEditing(true)
            MBProgressHUD.showAdded(to: self.view!, animated: true)
            UserManager().callingLogInApi(with: getLoginRequestBody(), success: {
                (model) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let model = model as? LogInResponseModel{
                    if model.statusCode == 1{
                       // User.saveUserData(userData: model)
                        CCUtility.processAfterLogIn()
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
    }
    
    func getLoginRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let email = self.textfieldEmail.text {
            dict.updateValue(email as AnyObject, forKey: "username")
        }
        if let password = self.textfieldPassword.text {
            dict.updateValue(password as AnyObject, forKey: "password")
        }
        return CCUtility.getJSONfrom(dictionary: dict)
    }
}

// MARK : -> ------ UITextField Delegates ------

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var message = String()
        guard let _text = textField.text else {
            return true
        }
        if textField == textfieldEmail {
            textfieldEmail.resignFirstResponder()
            textfieldPassword.becomeFirstResponder()
        } else {
            textfieldPassword.resignFirstResponder()
        }
        return true
    }
    
    func isValidLogInDetails()->Bool{
        var valid = true
        var messageString = ""
        if (self.textfieldEmail.text?.isEmpty)! {
            messageString = "Please enter email id"
            valid = false
        }
        else if !(self.textfieldEmail.text?.isValidEmail())! {
            messageString = "Please enter valid email id"
            valid = false
        }
        else if (self.textfieldPassword.text?.isEmpty)! {
            messageString = "Please enter password"
            valid = false
        }
        if !valid {
             CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: messageString, parentController: self)
        }
        return valid
    }

}

// MARK : -> ------ UITapGestureRecognizer Delegates ------

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
