//
//  HomeVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 7/4/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HomeListTVDelegate {
    
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    let topCollectionArray = ["Events","Hotels","Bar","What2Do"]
    var suggestionResponseModel:SuggestionsResponseModel?
    override func initView() {
        super.initView()
        registeringCollectionViewCells()
        self.navigationController?.navigationBar.isHidden = true
        addShadowToAView(shadowView: searchView)
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        getSuggestions()
        // Do any additional setup after loading the view.
    }
    
    func getSuggestions(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        EventManager().callingSuggestionsApi(with: "", success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? SuggestionsResponseModel{
                if model.statusCode == 1{
                    self.suggestionResponseModel = model
                    self.listCollectionView.reloadData()
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
    
    func registeringCollectionViewCells(){
        self.topCollectionView.register(UINib(nibName: "HomeHeadingCVC", bundle: nil), forCellWithReuseIdentifier: "homeHeadingCell")
        self.listCollectionView.register(UINib(nibName: "HomeListCVC", bundle: nil), forCellWithReuseIdentifier: "homeListCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.topCollectionView){
            return topCollectionArray.count
        }
        else{
            return topCollectionArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.topCollectionView){
            let homeHeadingCVC : HomeHeadingCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "homeHeadingCell", for: indexPath) as! HomeHeadingCVC
            homeHeadingCVC.itemNameLabel.text = topCollectionArray[indexPath.row]
            return homeHeadingCVC
        }
        else{
            let homeListCVC : HomeListCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "homeListCell", for: indexPath) as! HomeListCVC
            homeListCVC.delegate = self
            if let sugResponseModel = self.suggestionResponseModel {
                homeListCVC.setSuggestionArray(sugArray: sugResponseModel.suggestions)
            }
            return homeListCVC
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == self.listCollectionView){
          
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == self.topCollectionView){
            return CGSize(width: 100, height: collectionView.frame.size.height)
        }
        else{
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: Home List Table View Delegates
    
    func selectedCellDelegateWithTag(tag: NSInteger) {
        let detailView = HomeDetailViewController(nibName: "HomeDetailViewController", bundle: nil)
        self.present(detailView, animated: true, completion: nil)
        
//        let itineraryVC = ItineraryViewController(nibName: "ItineraryViewController", bundle: nil)
//        self.present(itineraryVC, animated: true, completion: nil)
//        let detailView = AddEventViewController(nibName: "AddEventViewController", bundle: nil)
//        self.present(detailView, animated: true, completion: nil)
    }
    
    func addToFavoriteFromClick(tag:NSInteger) {
        callingAddToFavoriteApi()
    }
    
    //MARK:- Add To Favorite Api integration
    
    func callingAddToFavoriteApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().addToFavoriteApi(with: addToFavoriteRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AddToFavoriteResponseModel{
                if model.statusCode == 1{
                    
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
    
    func addToFavoriteRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let user = User.getUser() {
            dict.updateValue(user.userId as AnyObject, forKey: "user_id")
        }
        //        if let sggId = "" {
        //            dict.updateValue(sggId as AnyObject, forKey: "sgg_id")
        //        }
        return CCUtility.getJSONfrom(dictionary: dict)
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
