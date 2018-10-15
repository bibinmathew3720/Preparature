//
//  HomeDetailViewController.swift
//  Preparture
//
//  Created by praveen raj on 07/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class HomeDetailViewController: BaseViewController, UIScrollViewDelegate {
    
    var eventItem:SuggestionItems?
    @IBOutlet weak var topCollectionView: UICollectionView!
    
    @IBOutlet weak var scrollFull: UIScrollView!
    @IBOutlet weak var viewScrollFull: UIView!
    @IBOutlet weak var scrollTop: UIScrollView!
    @IBOutlet weak var viewScrollTop: UIView!
    @IBOutlet weak var imageTop: UIImageView!
    @IBOutlet weak var pageControllTop: UIPageControl!
    @IBOutlet weak var labelTopName: UILabel!
    @IBOutlet weak var labelReviewsCount: UILabel!
    @IBOutlet weak var starTopFirst: UIImageView!
    @IBOutlet weak var starTopSecond: UIImageView!
    @IBOutlet weak var starTopThird: UIImageView!
    @IBOutlet weak var starTopFourth: UIImageView!
    @IBOutlet weak var starTopFifth: UIImageView!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelPerDay: UILabel!
    @IBOutlet weak var labelEventName: UILabel!
    @IBOutlet weak var labelEventPlace: UILabel!
    @IBOutlet weak var labelEventDate: UILabel!
    @IBOutlet weak var labelTravelExp: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    @IBOutlet weak var imageReviewer: UIImageView!
    @IBOutlet weak var labelReviewerName: UILabel!
    @IBOutlet weak var labelReviewerDate: UILabel!
    @IBOutlet weak var starReviewerFirst: UIImageView!
    @IBOutlet weak var starReviewerSecond: UIImageView!
    @IBOutlet weak var starReviewerThird: UIImageView!
    @IBOutlet weak var starReviewerFourth: UIImageView!
    @IBOutlet weak var starReviewerFifth: UIImageView!
    @IBOutlet weak var labelReviewComments: UILabel!
    @IBOutlet weak var imageReview: UIImageView!
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    @IBOutlet weak var viewTopStar: UIView!
    @IBOutlet weak var constraintSrollTopWidth: NSLayoutConstraint!
    @IBOutlet weak var viewReviewFull: UIView!
    @IBOutlet weak var labelNoSuggestions: UILabel!
    var categoryResponseModel:NSArray?
    
    override func initView() {
        super.initView()
        customization()
        populateSuggestionDetails()
        //callingGetSuggestionDetailsApi()
    }
    
    func customization() {
        self.scrollTop.delegate = self
        topCollectionView.register(UINib(nibName: "ImagesCVC", bundle: nil), forCellWithReuseIdentifier:"imageCVC" )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.constraintSrollTopWidth.constant = UIScreen.main.bounds.width * CGFloat(colors.count)
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
        scrollTop.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    @IBAction func actionReadReviews(_ sender: Any) {
        let suggestionsVC = SuggestionsViewController(nibName: "SuggestionsViewController", bundle: nil)
        suggestionsVC.eventItem = eventItem
        suggestionsVC.categoryResponseModel = categoryResponseModel
        self.present(suggestionsVC, animated: true, completion: nil)
    }
    
    //MARK:- Add To Favorite Api integration
    
    func callingGetSuggestionDetailsApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        EventManager().callingSuggestionDetailsApi(with: getSuggestionDetailsRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? SuggestionDetailResponseModel{
                if model.statusCode == 1{
                   self.eventItem = model.suggestionItem
                    self.populateSuggestionDetails()
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
    
    func getSuggestionDetailsRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let sugIt = eventItem {
            dict.updateValue(sugIt.eventId as AnyObject, forKey: "event_id")
        }
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
    func populateSuggestionDetails(){
        self.labelTopName.text = self.eventItem?.name
        self.labelComments.text = self.eventItem?.comments
        if self.labelComments.text == "" {
            self.labelComments.text = "No comments"
        }
        self.labelEventName.text = self.eventItem?.placeName
        self.labelEventPlace.text = self.eventItem?.placeLocation
        self.labelEventDate.text = CCUtility.convertToDateToFormat(inputDate: (self.eventItem?.createdDate)!, inputDateFormat: "yyyy-MM-dd HH:mm:ss", outputDateFormat: "dd/MM/yyyy")
        self.labelTravelExp.text = eventItem?.travelExp
        if self.labelTravelExp.text == "" {
            self.labelTravelExp.text = "No travel experience"
        }
        labelReviewsCount.text = eventItem?.totalReviews
        self.topCollectionView.reloadData()
        if eventItem?.totalReviews == "0" {
            viewReviewFull.isHidden = true
            labelNoSuggestions.isHidden = false
        } else {
            viewReviewFull.isHidden = false
            labelNoSuggestions.isHidden = true
        }
        populateEventImages()
    }
    
    func populateEventImages(){
        let imagesCount = self.eventItem?.placeImages.count
        self.pageControllTop.numberOfPages = imagesCount!
        if let imgCont = imagesCount {
            for index in 0..<imgCont {
                frame.origin.x = UIScreen.main.bounds.size.width * CGFloat(index)
                frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: self.scrollTop.frame.size.height)
                
                let subView = UIImageView(frame: frame)
                subView.sd_setImage(with: URL(string: (self.eventItem?.placeImages[index])!), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
                self.viewScrollTop.addSubview(subView)
            }
        }
        self.viewScrollTop.bringSubview(toFront: labelTopName)
        self.viewScrollTop.bringSubview(toFront: pageControllTop)
        self.viewScrollTop.bringSubview(toFront: viewTopStar)

    }
}

extension HomeDetailViewController :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.eventItem?.placeImages.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCVC", for: indexPath) as! ImagesCVC
        cell.setImageUrlString(imageUrlString: (self.eventItem?.placeImages[indexPath.row])!)
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
