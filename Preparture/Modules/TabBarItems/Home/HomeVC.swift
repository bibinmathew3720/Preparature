//
//  HomeVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 7/4/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    override func initView() {
        super.initView()
        self.view.backgroundColor = UIColor.red
        registeringCollectionViewCells()
        // Do any additional setup after loading the view.
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.topCollectionView){
            let homeHeadingCVC : HomeHeadingCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "homeHeadingCell", for: indexPath) as! HomeHeadingCVC
            return homeHeadingCVC
        }
        else{
            let homeListCVC : HomeListCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "homeListCell", for: indexPath) as! HomeListCVC
            return homeListCVC
        }
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
