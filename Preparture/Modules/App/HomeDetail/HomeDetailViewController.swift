//
//  HomeDetailViewController.swift
//  Preparture
//
//  Created by praveen raj on 07/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class HomeDetailViewController: BaseViewController, UIScrollViewDelegate {
    
    var eventItem:EventItem?
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var labelReviewsCount: UILabel!
    @IBOutlet weak var labelTopName: UILabel!
    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var eventPriceLabel: UILabel!
    @IBOutlet weak var labelEventOwnerName: UILabel!
    @IBOutlet weak var labelEventPlace: UILabel!
    @IBOutlet weak var labelEventDate: UILabel!
    @IBOutlet weak var labelTravelExp: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    
    @IBOutlet weak var viewScrollFull: UIView!
    @IBOutlet weak var pageControllTop: UIPageControl!
    
    @IBOutlet weak var reviewerStar1Button: UIButton!
    @IBOutlet weak var reviewerStar2Button: UIButton!
    @IBOutlet weak var reviewerStar3Button: UIButton!
    @IBOutlet weak var reviewrStar4Button: UIButton!
    @IBOutlet weak var reviewerStar5Button: UIButton!
    
    
    @IBOutlet weak var imageReviewer: UIImageView!
    @IBOutlet weak var labelReviewerName: UILabel!
    @IBOutlet weak var labelReviewerDate: UILabel!
    @IBOutlet weak var labelReviewComments: UILabel!
    @IBOutlet weak var imageReview: UIImageView!
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    //var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    
    @IBOutlet weak var viewReviewFull: UIView!
    @IBOutlet weak var labelNoSuggestions: UILabel!
    var categoryResponseModel:NSArray?
    
    override func initView() {
        super.initView()
        customization()
        populateEventDetails()
        callingGetEventDetailsApi()
    }
    
    func customization() {
        topCollectionView.register(UINib(nibName: "ImagesCVC", bundle: nil), forCellWithReuseIdentifier:"imageCVC" )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    //MARK:- UIScrollView Delegate Methods
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControllTop.currentPage = Int(pageNumber)
    }

    //MARK:- UIView Action Methods
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func actionPageControllValueChanged(_ sender: UIPageControl) {
        let x = CGFloat(pageControllTop.currentPage) * UIScreen.main.bounds.size.width
    }
    
    @IBAction func actionReadReviews(_ sender: Any) {
        let suggestionsVC = SuggestionsViewController(nibName: "SuggestionsViewController", bundle: nil)
        //suggestionsVC.eventItem = eventItem
        suggestionsVC.categoryResponseModel = categoryResponseModel
        self.present(suggestionsVC, animated: true, completion: nil)
    }
    
    //MARK:- Get Event Details Api Integration
    
    func callingGetEventDetailsApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        EventManager().callingEventDetailsApi(with: getEventDetailsRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? EventDetailResponseModel{
                if model.statusCode == 1{
                   self.eventItem = model.eventItem
                    self.populateEventDetails()
                }
                else{
                    CCUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.statusMessage, parentController: self)
                }
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
    
    func getEventDetailsRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let eventIt = eventItem {
            dict.updateValue(eventIt.eventId as AnyObject, forKey: "event_id")
        }
        if let user = User.getUser(){
            dict.updateValue(user.userId as AnyObject, forKey: "user_id")
        }
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
    func populateEventDetails(){
        if let eventIt = self.eventItem {
            self.labelTopName.text = eventIt.name
            self.pageControllTop.numberOfPages = eventIt.eventImages.count
            self.favoriteButton.isSelected = eventIt.isFavourite
            self.setTopRatingStar(rating: eventIt.rating)
            self.eventPriceLabel.text = String (format: "%0.2f", eventIt.eventCost)
            self.labelEventOwnerName.text = eventIt.eventOwnerName
            self.labelEventPlace.text = eventIt.location
            self.labelEventDate.text = CCUtility.convertToDateToFormat(inputDate: eventIt.eventDate, inputDateFormat: "yyyy-MM-dd HH:mm:ss", outputDateFormat: "dd/MM/yyyy")
            if self.labelTravelExp.text == "" {
                self.labelTravelExp.text = "No travel experience"
            }
            else{
               self.labelTravelExp.text = eventIt.travelExperience
            }
            if eventIt.comments == "" {
                self.labelComments.text = "No comments"
            }
            else{
               self.labelComments.text = eventIt.comments
            }
            labelReviewsCount.text = String (format: "%d", eventIt.reviewsCount)
            self.topCollectionView.reloadData()
            if eventIt.reviewsCount == 0 {
                viewReviewFull.isHidden = true
                labelNoSuggestions.isHidden = false
            } else {
                viewReviewFull.isHidden = false
                labelNoSuggestions.isHidden = true
            }
        }
    }
    
    func setTopRatingStar(rating:Int){
        self.star1Button.isSelected = false
        self.star2Button.isSelected = false
        self.star3Button.isSelected = false
        self.star4Button.isSelected = false
        self.star5Button.isSelected = false
        if (rating == 1){
            self.star1Button.isSelected = true
        }
        else if (rating == 2){
            self.star1Button.isSelected = true
            self.star2Button.isSelected = true
        }
        else if (rating == 3){
            self.star1Button.isSelected = true
            self.star2Button.isSelected = true
            self.star3Button.isSelected = true
        }
        else if (rating == 4){
            self.star1Button.isSelected = true
            self.star2Button.isSelected = true
            self.star3Button.isSelected = true
            self.star4Button.isSelected = true
        }
        else if (rating == 5){
            self.star1Button.isSelected = true
            self.star2Button.isSelected = true
            self.star3Button.isSelected = true
            self.star4Button.isSelected = true
            self.star5Button.isSelected = true
        }
    }
}

extension HomeDetailViewController :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let eventIt = self.eventItem {
            return eventIt.eventImages.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCVC", for: indexPath) as! ImagesCVC
        if let eventIt = self.eventItem {
            cell.setImageUrlString(imageUrlString: (eventIt.eventImages[indexPath.row]))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
