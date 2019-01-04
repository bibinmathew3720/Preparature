//
//  EditProfileViewController.swift
//  Preparture
//
//  Created by praveen raj on 07/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit
import Alamofire

class EditProfileViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    var fileUploadResponseModel:FileUploadResponseModel?
    var selImage:UIImage?
    var imagePathExtension:String?
    override func initView() {
        super.initView()
        customization()
    }

    func customization() {
        populateUserDetails()
        
    }
    
    func populateUserDetails(){
        if let user = User.getUser() {
            self.nameTF.text = user.name
            self.userNameTF.text = user.userName
            self.emailTF.text = user.email
            self.imageProfile.sd_setImage(with: URL(string: user.imageUrl!), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
        }
    }

    @IBAction func actionEdit(_ sender: Any) {
       enableEditing()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func viewGestureAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        addingActionSheetForPhotos()
    }
    @IBAction func updateButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if (self.isValidEditProfileDetails()){
            if let image = self.selImage {
                sendProfileImage(image: image, ext: self.imagePathExtension!)
            }
            else{
                callingEditProfileApi()
            }
        }
    }
    
    func isValidEditProfileDetails()->Bool{
        var valid = true
        var messageString = ""
        if (self.nameTF.text?.isEmpty)!{
            messageString = "Please enter valid name"
            valid = false
        }
        if !valid {
            CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: messageString, parentController: self)
        }
        return valid
    }
    
    func enableEditing(){
        self.nameTF.isEnabled = true
        self.nameTF.becomeFirstResponder()
        self.cameraButton.isHidden = false
        self.updateButton.isHidden = false
    }
    
    func disableEditing(){
        self.nameTF.isEnabled = false
        self.view.endEditing(true)
        self.cameraButton.isHidden = true
        self.updateButton.isHidden = true
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
            }
            else {
                imagePathExtension = "JPG"
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func callingEditProfileApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().callingEditProfileApi(with: getEditProfileRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? EditProfileResponseModel{
                if model.statusCode == 1{
                    if let user = User.getUser(){
                        user.name = self.nameTF.text
                        if let fileReponse = self.fileUploadResponseModel {
                            user.imageUrl = fileReponse.uploadedImageName
                        }
                        CoreDataHandler.sharedInstance.saveContext()
                    }
                    self.disableEditing()
                    CCUtility.showDefaultAlertwithCompletionHandler(_title: Constant.AppName, _message: "Profile Updated successfully", parentController: self, completion: { (status) in
                        
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
    
    func getEditProfileRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let name = self.nameTF.text {
            dict.updateValue(name as AnyObject, forKey: "name")
        }
        if let filUploadResponse = self.fileUploadResponseModel {
            dict.updateValue(filUploadResponse.uploadedImageName as AnyObject, forKey: "user_image")
        }
        else{
            if let user = User.getUser() {
                dict.updateValue(user.imageUrl as AnyObject, forKey: "user_image")
            }
        }
        if let user = User.getUser() {
            dict.updateValue(user.userId as AnyObject, forKey: "user_id")
        }
        return CCUtility.getJSONfrom(dictionary: dict)
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
            self.callingEditProfileApi()
            //self.callingSignUpApi()
            print(response)
        }) { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(error)
        }
        
    }
    
    
}

extension EditProfileViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

