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
    var categoryResponseModel:GetAllCategoryResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        customization()
        callingGetCategoriesApi()
    }
    
    func callingGetCategoriesApi(){
        self.getAllCategoryApi { (status, categoryResponse) in
            if status{
                self.categoryResponseModel = categoryResponse
                self.collectionViewEvents.reloadData()
            }
        }
    }

    func customization() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.collectionViewEvents.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCollectionViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HomeEventsViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let catResponse = self.categoryResponseModel {
            return catResponse.categoryItems.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let homeHeadingCVC : CategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        if let catResponse = self.categoryResponseModel {
            homeHeadingCVC.setCategoryArray(categoryItem: catResponse.categoryItems[indexPath.row])
        }
        
        return homeHeadingCVC
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homeVC:HomeVC = HomeVC(nibName: "HomeVC", bundle: nil)
        if let catResponse = self.categoryResponseModel{
            homeVC.itemDetail = catResponse.categoryItems[indexPath.row]
            homeVC.categoryResponseModel = catResponse.categoryItems as NSArray
        }
        let nav:UINavigationController = UINavigationController.init(rootViewController: homeVC)
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
