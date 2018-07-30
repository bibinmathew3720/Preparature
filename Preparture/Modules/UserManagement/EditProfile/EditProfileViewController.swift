//
//  EditProfileViewController.swift
//  Preparture
//
//  Created by praveen raj on 07/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    
    var fileUploadResponseModel:FileUploadResponseModel?
    var selImage:UIImage?
    var imagePathExtension:String?
    override func initView() {
        super.initView()
        customization()
    }

    func customization() {
        
    }

    @IBAction func actionEdit(_ sender: Any) {
        self.nameTF.isEnabled = true
        self.nameTF.becomeFirstResponder()
        self.cameraButton.isHidden = false
    }
    
    @IBAction func viewGestureAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        addingActionSheetForPhotos()
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
    
    //MARK: Sending Chat Image
    
    func sendProfileImage(image:UIImage, ext: String){
        let imageData = UIImageJPEGRepresentation(image, 0.25)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CLNetworkManager.upload(file: imageData!,
                                type: .JPEG, ext: ext,
                                url: BASE_URL+IMAGE_UPLOAD_URL,
                                parameters: "files",
                                headers: nil)
        {
            (response, status, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if status == true {
                if let res = response {
                    self.fileUploadResponseModel = FileUploadResponseModel.init(dict: res)
//                    self.callingSignUpApi()
                }
            }
            else{
                if(error == .noNetwork){
                    CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
                }
                else{
                    CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
                }
            }
        }
    }
    
    
}

extension EditProfileViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

