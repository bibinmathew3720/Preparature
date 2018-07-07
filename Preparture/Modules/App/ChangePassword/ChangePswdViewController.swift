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
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
