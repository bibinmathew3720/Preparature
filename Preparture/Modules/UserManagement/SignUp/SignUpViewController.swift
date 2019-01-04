//
//  SignUpViewController.swift
//  Preparture
//
//  Created by praveen raj on 24/06/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit
import Photos

class SignUpViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tickButton: UIButton!
    
    var fileUploadResponseModel:FileUploadResponseModel?
    var selImage:UIImage?
    var imagePathExtension:String?
    override func initView() {
        super.initView()

        // Do any additional setup after loading the view.
    }
    @IBAction func actionCamera(_ sender: Any) {
        self.view.endEditing(true)
        addingActionSheetForPhotos()
    }
    @IBAction func actionSignup(_ sender: Any) {
        self.view.endEditing(true)
        if (self.isValidSignUpDetails()){
            if let image = self.selImage {
                sendProfileImage(image: image, ext: self.imagePathExtension!)
            }
            else{
                callingSignUpApi()
            }
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
        if tickButton.isSelected{
            dict.updateValue("2" as AnyObject, forKey: "user_type")
        }
        else{
            dict.updateValue("0" as AnyObject, forKey: "user_type")
        }
        if let filUploadResponse = self.fileUploadResponseModel {
           dict.updateValue(filUploadResponse.uploadedImageName as AnyObject, forKey: "user_image")
        }
        else{
             dict.updateValue("" as AnyObject, forKey: "user_image")
        }
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
    @IBAction func actioonBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    @IBAction func tickButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
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
    
    func addingActionSheetForPhotos(){
        let photoActionSheet = UIAlertController.init(title: "Choose an option", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction.init(title: "Camera", style: .destructive) { (alert:UIAlertAction) in
            self.addingImagePickerController(sourceType: .camera)
        }
        let galleryAction = UIAlertAction.init(title: "Choose from Gallery", style: .default) { (alert:UIAlertAction) in
            self.addingImagePickerController(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (alert:UIAlertAction) in
            
        }
        photoActionSheet.addAction(cameraAction)
        photoActionSheet.addAction(galleryAction)
        photoActionSheet.addAction(cancelAction)
        present(photoActionSheet, animated: true, completion: nil)
    }
    
    func addingImagePickerController(sourceType:UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType;
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let referenceURL = info["UIImagePickerControllerReferenceURL"] as? URL
            selImage = pickedImage
            imageProfile.image = selImage
            if let refUrl = referenceURL {
                imagePathExtension = refUrl.pathExtension
                //sendChatImage(image: pickedImage, ext: (refUrl.pathExtension))
            }
            else {
                imagePathExtension = "JPG"
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Upload Profile Image
    
    func sendProfileImage(image:UIImage, ext: String){
        let imageData = UIImageJPEGRepresentation(image, 0.25)
        let imagesDataArray = [imageData]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let imageUploadUrl = BASE_URL + IMAGE_UPLOAD_URL
        UserManager().requestWith(endUrl: imageUploadUrl, imagesDatas: imagesDataArray as! [Data], parameters: ["":""], onCompletion: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.fileUploadResponseModel = response
            self.callingSignUpApi()
            print(response)
        }) { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(error)
        }
        
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
