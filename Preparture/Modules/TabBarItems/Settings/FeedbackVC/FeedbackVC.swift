//
//  FeedbackVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 1/26/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit
import GrowingTextView

class FeedbackVC: BaseViewController,UITextViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTV: GrowingTextView!
    let feedBack = Feedback()
    override func initView() {
        super.initView()
        customization()
    }
    
    func customization() {
        
    }
    
    @IBAction func backButtpnAction(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        if (isValid()){
            callingSubmitFeedbackApi()
        }
    }
    
    func isValid()->Bool{
        if (!feedBack.title.isValidString()){
            if (!feedBack.feedDescription.isValidString()){
                return true
            }
            else{
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: "Please enter description", parentController: self)
                return false
            }
        }
        else{
            CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: "Please enter title", parentController: self)
            return false
        }
    }
    
    func callingSubmitFeedbackApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().callingFeedbackApi(with: feedBack.getRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? ForgotResponseModel{
                if model.statusCode == 1{
                    CCUtility.showDefaultAlertwithCompletionHandler(_title: Constant.AppName, _message: "Feedback submitted successfully", parentController: self, completion: { (status) in
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
    
    @IBAction func editingChangedAction(_ sender: UITextField) {
        if let textString = sender.text{
            feedBack.title = textString
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        feedBack.feedDescription = textView.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionTV.becomeFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class Feedback:NSObject{
    var title:String = ""
    var feedDescription:String = ""
    func getRequestBody()->String{
        var dict:[String:String] = [String:String]()
        if let user = User.getUser(){
            if let userIdString = user.userId{
                dict.updateValue(userIdString, forKey: "user_id")
            }
        }
        dict.updateValue(title, forKey: "feedback_title")
        dict.updateValue(feedDescription, forKey: "feedback_description")
        return CCUtility.getJSONfrom(dictionary: dict)
    }
}
