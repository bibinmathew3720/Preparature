//
//  SuggestionsViewController.swift
//  Preparture
//
//  Created by praveen raj on 07/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit
import AVFoundation
import PhotosUI
import MobileCoreServices

enum AttachmentType: String{
    case camera, video, photoLibrary
}
class SuggestionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate, UIDocumentMenuDelegate {
 
    let SuggestionTextViewPlaceholder = "Write your suggestions"
    
    @IBOutlet weak var tableviewReviews: UITableView!
    @IBOutlet weak var textViewSuggestions: UITextView!
    @IBOutlet weak var buttonStarFirst: UIButton!
    @IBOutlet weak var buttonStarSecond: UIButton!
    @IBOutlet weak var buttonStarThird: UIButton!
    @IBOutlet weak var buttonStarForth: UIButton!
    @IBOutlet weak var buttonStarFifth: UIButton!
    
    @IBOutlet weak var suggestionImageView: UIImageView!
    @IBOutlet weak var buttonAddImg: UIButton!
    @IBOutlet weak var collectionViewVdo: UICollectionView!
    var eventItem:EventItem?
    var arraySuggestions = NSMutableArray()
    @IBOutlet weak var labelNoSuggestions: UILabel!
    
    //MARK: - Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    var videoPickedBlock: ((NSURL) -> Void)?
    var filePickedBlock: ((URL) -> Void)?
    var imageArray = NSMutableArray()
    
    var rateIndex:Int = 0
    var selImage:UIImage?
    var suggestionModel:GetSuggestionsResponseModel?
    var fileUploadResponseModel:FileUploadResponseModel?
    
    override func initView() {
        super.initView()
        customization()
    }
    
    func customization() {
        tableCellRegistration()
        getAllSuggestionsApi()
    }
    
    //MARK: -> ------ UITextView Delegates ------
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var frame = textView.frame
        frame.size.height = textView.contentSize.height
        if frame.size.height > 70 {
            frame.size.height = 70
            frame.origin.y = 5
        } else {
            frame.origin.y = 25
        }
        textView.frame = frame
        if(text == "\n") {
            textView.resignFirstResponder()
            if textView.text.count == 0 {
                textView.text = ""
            }
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == SuggestionTextViewPlaceholder {
            textView.text = ""
        }
    }
    
    //MARK:- UIView Action Methods
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionAddIMage(_ sender: Any) {
        self.showAttachmentActionSheet(vc: self)
    }
    
    @IBAction func actionStarFirst(_ sender: Any) {
        rateIndex = 1
        selectStarRate(isFirst: true, isSecond: false, isThird: false, isForth: false, isFifth: false)
    }
    
    @IBAction func actionStarSecond(_ sender: Any) {
        rateIndex = 2
        selectStarRate(isFirst: true, isSecond: true, isThird: false, isForth: false, isFifth: false)
    }
    
    @IBAction func actionStarThird(_ sender: Any) {
        rateIndex = 3
        selectStarRate(isFirst: true, isSecond: true, isThird: true, isForth: false, isFifth: false)
    }
    
    @IBAction func actionStarFourth(_ sender: Any) {
        rateIndex = 4
        selectStarRate(isFirst: true, isSecond: true, isThird: true, isForth: true, isFifth: false)
    }
    
    @IBAction func actionStarFifth(_ sender: Any) {
        rateIndex = 5
        selectStarRate(isFirst: true, isSecond: true, isThird: true, isForth: true, isFifth: true)
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        if (isValidSuggestion()){
            if let seletedImage = self.selImage {
                sendSuggestionImage(image: seletedImage, ext: "")
            }
        }
    }
    
    func isValidSuggestion()->Bool{
        var isValid = true
        var messageString = ""
        if self.rateIndex == 0 {
            messageString = "Please rate the event"
            isValid = false
        }
        else if let commentTV = self.textViewSuggestions {
            if (commentTV.text.count == 0 || (commentTV.text == SuggestionTextViewPlaceholder)){
                messageString = "Please enter your comment that helps others to analyse the event"
                isValid = false
            }
            else{
                if let seImage = self.selImage {
                    
                }
                else{
                    messageString = "Please add event images"
                    isValid = false
                }
            }
        }
        if !isValid {
            CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: messageString, parentController: self)
        }
        return isValid
    }
    
    func displayImage(){
        if let selectedImage = self.selImage {
            self.suggestionImageView.image = selectedImage
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // To handle image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickedBlock?(image)
            self.selImage = image
            self.displayImage()
            if let urlName = info[UIImagePickerControllerReferenceURL] as? URL {
                imageArray.add(urlName)
                collectionViewVdo.reloadData()
            }
        } else{
            print("Something went wrong in  image")
        }
        
        // To handle video
        
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL{
            print("videourl: ", videoUrl)
            //trying compression of video
            let data = NSData(contentsOf: videoUrl as URL)!
            print("File size before compression: \(Double(data.length / 1048576)) mb")
            compressWithSessionStatusFunc(videoUrl)
        }
        else{
            print("Something went wrong in  video")
        }
        self.dismiss(animated: true, completion: nil)
    }
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
        
        fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
            let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MOV")
            compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
                guard let session = exportSession else {
                    return
                }
                
                switch session.status {
                case .completed:
                    guard let compressedData = NSData(contentsOf: compressedURL) else {
                        return
                    }
                    print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                    
                    DispatchQueue.main.async {
                        self.videoPickedBlock?(compressedURL as NSURL)
                    }
                case .unknown:
                    break
                case .waiting:
                    break
                case .exporting:
                    break
                case .failed:
                    break
                case .cancelled:
                    break
                default:
                    break
                }
            }
    }
    //MARK:- Rate Selection
    
    func selectStarRate(isFirst: Bool, isSecond: Bool, isThird: Bool, isForth: Bool, isFifth: Bool) {
        buttonStarFirst.isSelected = isFirst
        buttonStarSecond.isSelected = isSecond
        buttonStarThird.isSelected = isThird
        buttonStarForth.isSelected = isForth
        buttonStarFifth.isSelected = isFifth
    }
    
    //MARK: Upload Suggestion Image
    
    func sendSuggestionImage(image:UIImage, ext: String){
        let imageData = UIImageJPEGRepresentation(image, 0.25)
        let imagesDataArray = [imageData]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let imageUploadUrl = BASE_URL + IMAGE_UPLOAD_URL
        UserManager().requestWith(endUrl: imageUploadUrl, imagesDatas: imagesDataArray as! [Data], parameters: ["":""], onCompletion: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.fileUploadResponseModel = response
            self.postSuggestionsApi()
            print(response)
        }) { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(error)
        }
        
    }
    
    //MARK:- Get Suggestions Api integration
    
    func getAllSuggestionsApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().getSuggestionsApi(with:getSuggestionsRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? GetSuggestionsResponseModel{
                if model.statusCode == 1{
                    if model.userSuggestions.count != 0 {
                        self.labelNoSuggestions.isHidden = true
                        self.tableviewReviews.isHidden = false
                    }
                    else{
                        self.labelNoSuggestions.isHidden = false
                        self.tableviewReviews.isHidden = true
                    }
                    self.suggestionModel = model
                    self.tableviewReviews.reloadData()
                                }
                //                else{
                //                    CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.statusMessage, parentController: self)
                //                }
            } else {
                //                if let model = model as? stat{
                //                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.statusMessage, parentController: self)
                //                }
            }
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            } else {
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
            print(ErrorType)
        }
    }
    
    func getSuggestionsRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let eventId = eventItem?.eventId {
            dict.updateValue(eventId as AnyObject, forKey: "event_id")
        }
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
    //MARK:- Post Suggestions Api integration
    
    func postSuggestionsApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().postSuggestionsApi(with:postSuggestionsRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? GetAllCategoryResponseModel{
                if model.statusCode == 1{
                    CCUtility.showDefaultAlertwithCompletionHandler(_title: Constant.AppName, _message: "Suggestion created Successfully", parentController: self, completion: { (status) in
                        self.dismiss(animated: true, completion: nil)
                    })
                }
                else{
                    CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.statusMessage, parentController: self)
                }
            } else {
                //                if let model = model as? stat{
                //                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.statusMessage, parentController: self)
                //                }
            }
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            } else {
                CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
            print(ErrorType)
        }
    }
    
    func postSuggestionsRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let user = User.getUser() {
            dict.updateValue(user.userId as AnyObject, forKey: "user_id")
        }
        if let eveItem = self.eventItem{
            dict.updateValue(eveItem.eventId as AnyObject, forKey: "event_id")
            dict.updateValue(eveItem.categoryId as AnyObject, forKey: "category_id")
        }
        dict.updateValue(rateIndex as AnyObject, forKey: "rating")
        dict.updateValue(textViewSuggestions.text as AnyObject, forKey: "comments")
        dict.updateValue("" as AnyObject, forKey: "title")
        if let fileUploadRes = self.fileUploadResponseModel {
            dict.updateValue(fileUploadRes.uploadedImageName as AnyObject, forKey: "place_files")
        }
        else{
            dict.updateValue("" as AnyObject, forKey: "place_files")
        }
        //"place_files": "image.jpg,video.mp4" ( File names are concatenate with comma - > check API No: 17)
        
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
    //MARK:- UITableViewCell Registration
    
    func tableCellRegistration(){
        tableviewReviews.register(UINib.init(nibName: "SuggestionsTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSuggestions")
        collectionViewVdo.register(UINib.init(nibName: "ImagesCVC", bundle: nil), forCellWithReuseIdentifier: "imageCVC")
    }
    
    //MARK:- UITableView Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = suggestionModel else {
            return 0
        }
        return (model.userSuggestions.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSuggestions", for: indexPath) as! SuggestionsTableViewCell
        if let sugModel = self.suggestionModel {
            cell.setModel(model:sugModel.userSuggestions[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    func showAttachmentActionSheet(vc: UIViewController) {
        view.endEditing(true)
        let actionSheet = UIAlertController(title: Constant.PhotoLibrary.actionFileTypeHeading, message: Constant.PhotoLibrary.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Constant.PhotoLibrary.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constant.PhotoLibrary.phoneLibrary, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self)
        }))
        
//        actionSheet.addAction(UIAlertAction(title: Constant.PhotoLibrary.video, style: .default, handler: { (action) -> Void in
//            self.authorisationStatus(attachmentTypeEnum: .video, vc: self)
//
//        }))
        
//        actionSheet.addAction(UIAlertAction(title: Constant.PhotoLibrary.file, style: .default, handler: { (action) -> Void in
//            self.documentPicker()
//        }))
        
        actionSheet.addAction(UIAlertAction(title: Constant.PhotoLibrary.cancelBtnTitle, style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    func documentPicker(){
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func videoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("url", url)
        self.filePickedBlock?(url)
    }
    
    //    Method to handle cancel action.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController){
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            if attachmentTypeEnum == AttachmentType.camera{
                openCamera()
            }
            if attachmentTypeEnum == AttachmentType.photoLibrary{
                photoLibrary()
            }
            if attachmentTypeEnum == AttachmentType.video{
                videoLibrary()
            }
        case .denied:
            print("permission denied")
            //self.addAlertForSettings(attachmentTypeEnum)
        case .notDetermined:
            print("Permission Not Determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    print("access given")
                    if attachmentTypeEnum == AttachmentType.camera{
                        self.openCamera()
                    }
                    if attachmentTypeEnum == AttachmentType.photoLibrary{
                        self.photoLibrary()
                    }
                    if attachmentTypeEnum == AttachmentType.video{
                        self.videoLibrary()
                    }
                }else{
                    print("restriced manually")
                    //self.addAlertForSettings(attachmentTypeEnum)
                }
            })
        case .restricted:
            print("permission restricted")
            //self.addAlertForSettings(attachmentTypeEnum)
        default:
            break
        }
    }
}

extension SuggestionsViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.count != 0 {
            return imageArray.count + 1
        }
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        buttonAddImg.isHidden = true
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCVC", for: indexPath) as! ImagesCVC
        if indexPath.row == imageArray.count {
            cell.eventImageView.image = #imageLiteral(resourceName: "addImageIcon")
        } else {
            cell.setImageUrl(imageUrlString: self.imageArray[indexPath.row] as! URL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == imageArray.count {
            self.showAttachmentActionSheet(vc: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
