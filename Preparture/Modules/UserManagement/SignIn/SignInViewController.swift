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
        
    }

    //MARK:- Action methods
    
    @IBAction func actionFacebookLogin(_ sender: Any) {
    }
    @IBAction func actionGooglePlusLogin(_ sender: Any) {
    }
    @IBAction func actionForgotPassword(_ sender: Any) {
    }
    @IBAction func actionContinue(_ sender: Any) {
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

}

