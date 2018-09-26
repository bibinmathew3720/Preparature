//
//  HomeEventsViewController.swift
//  Preparture
//
//  Created by Nimmy K Das on 9/8/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class HomeEventsViewController: BaseViewController {

    @IBOutlet weak var collectionViewEvents: UICollectionView!
    var categoryResponseModel:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customization()
    }

    func customization() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.collectionViewEvents.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCollectionViewCell")

        getAllCategoryApi()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIView Action method
    
    @IBAction func actionAdd(_ sender: Any) {
        let vc:AddEventViewController = AddEventViewController(nibName: "AddEventViewController", bundle: nil)
        let navController:UINavigationController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated: false, completion: nil)
    }
    
    //MARK:- Get All Categories Api integration
    
    func getAllCategoryApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().getCategoryApi(with: "", success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? GetAllCategoryResponseModel{
                //if model.statusCode == 1{
                self.categoryResponseModel = model.categoryItems as NSArray
                    self.collectionViewEvents.reloadData()
//                }
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
    
}

extension HomeEventsViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let array = categoryResponseModel {
            return (categoryResponseModel?.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let homeHeadingCVC : CategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        homeHeadingCVC.setCategoryArray(categoryItem: categoryResponseModel?.object(at: indexPath.row) as! CategoryItem)
        return homeHeadingCVC
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homeVC:HomeVC = HomeVC(nibName: "HomeVC", bundle: nil)
        homeVC.itemDetail = categoryResponseModel?.object(at: indexPath.row) as? CategoryItem
        let nav:UINavigationController = UINavigationController.init(rootViewController: homeVC)
        //self.navigationController?.pushViewController(homeVC, animated: true)
        self.present(nav, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width - 50)/2, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
