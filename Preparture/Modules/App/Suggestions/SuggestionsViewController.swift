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
class SuggestionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate, UIDocumentMenuDelegate {

    @IBOutlet weak var tableviewReviews: UITableView!
    @IBOutlet weak var tfType: UITextField!
    @IBOutlet weak var textViewSuggestions: UITextView!
    @IBOutlet var pickerViewType: UIPickerView!
    @IBOutlet var toolBarPicker: UIToolbar!
    @IBOutlet weak var buttonStarFirst: UIButton!
    var pickerArray = ["Hotels", "Hospitals", "Restaurants"]
    var selectedIndex:NSInteger = 0
    @IBOutlet weak var buttonStarSecond: UIButton!
    @IBOutlet weak var buttonStarThird: UIButton!
    @IBOutlet weak var buttonStarForth: UIButton!
    @IBOutlet weak var buttonStarFifth: UIButton!
    @IBOutlet weak var buttonAddImg: UIButton!
    @IBOutlet weak var collectionViewVdo: UICollectionView!
    
    
    //MARK: - Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    var videoPickedBlock: ((NSURL) -> Void)?
    var filePickedBlock: ((URL) -> Void)?
    
    override func initView() {
        super.initView()
        
        customization()
    }
    
    func customization() {
        tableCellRegistration()
        tfType.inputView = pickerViewType
        tfType.inputAccessoryView = toolBarPicker
        pickerViewType.translatesAutoresizingMaskIntoConstraints = false
        toolBarPicker.translatesAutoresizingMaskIntoConstraints = false
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
                textView.text = "Write your suggestions"
            }
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write your suggestions" {
            textView.text = ""
        }
    }

    //MARK: -> ------ UIPickerView Delegates ------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
    
    //MARK:- UIView Action Methods
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionAddIMage(_ sender: Any) {
        self.showAttachmentActionSheet(vc: self)
    }
    
    @IBAction func actionStarFirst(_ sender: Any) {
        selectStarRate(isFirst: true, isSecond: false, isThird: false, isForth: false, isFifth: false)
    }
    
    @IBAction func actionStarSecond(_ sender: Any) {
        selectStarRate(isFirst: true, isSecond: true, isThird: false, isForth: false, isFifth: false)
    }
    
    @IBAction func actionStarThird(_ sender: Any) {
        selectStarRate(isFirst: true, isSecond: true, isThird: true, isForth: false, isFifth: false)
    }
    
    @IBAction func actionStarFourth(_ sender: Any) {
        selectStarRate(isFirst: true, isSecond: true, isThird: true, isForth: true, isFifth: false)
    }
    
    @IBAction func actionStarFifth(_ sender: Any) {
        selectStarRate(isFirst: true, isSecond: true, isThird: true, isForth: true, isFifth: true)
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
    }
    
    @IBAction func actionToolbarDone(_ sender: Any) {
        guard let code:String = pickerArray[selectedIndex] else {
            return
        }
        tfType.text = code
        tfType.resignFirstResponder()
    }
    
    @IBAction func actionToolbarCancel(_ sender: Any) {
        tfType.resignFirstResponder()
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // To handle image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickedBlock?(image)
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSuggestions", for: indexPath) as! SuggestionsTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func showAttachmentActionSheet(vc: UIViewController) {
        let actionSheet = UIAlertController(title: Constant.PhotoLibrary.actionFileTypeHeading, message: Constant.PhotoLibrary.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Constant.PhotoLibrary.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constant.PhotoLibrary.phoneLibrary, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constant.PhotoLibrary.video, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .video, vc: self)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constant.PhotoLibrary.file, style: .default, handler: { (action) -> Void in
            self.documentPicker()
        }))
        
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCVC", for: indexPath) as! ImagesCVC
        //cell.setImageUrlString(imageUrlString: (self.eventItem?.placeImages[indexPath.row])!)
        return cell
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
