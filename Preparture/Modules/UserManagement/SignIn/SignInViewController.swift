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
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Muli-Bold", size: 23)!])
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:24,length:7))
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
