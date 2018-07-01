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
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
