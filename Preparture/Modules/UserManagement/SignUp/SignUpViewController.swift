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
