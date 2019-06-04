//
//  FavoritesVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 7/4/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class FavoritesVC: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var noItemsFoundLabel: UILabel!
    @IBOutlet weak var favoriteTableView: UITableView!
    var favoriteResponseModel:ListAllFavoriteResponseModel?
    override func initView() {
        super.initView()
        tableCellRegistration()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func plusButtonAction(_ sender: UIButton) {
        let vc:AddEventViewController = AddEventViewController(nibName: "AddEventViewController", bundle: nil)
        let navController:UINavigationController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        callingListAllFavoriteApi()
    }
    
    func tableCellRegistration(){
        favoriteTableView.register(UINib.init(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "favoriteCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let favoritResponse = self.favoriteResponseModel{
            return favoritResponse.favoriteItems.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as!FavoriteCell
        if let favoritResponse = self.favoriteResponseModel{
             cell.setFavoriteitem(favorite:favoritResponse.favoriteItems[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let favResponse = self.favoriteResponseModel {
            let favoriteItem:EventItem = favResponse.favoriteItems[indexPath.row]
            let detailVC = HomeDetailViewController(nibName: "HomeDetailViewController", bundle: nil)
            detailVC.eventItem = favoriteItem
            //detailVC.categoryResponseModel = categoryResponseModel
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    //MARK:- Add To Favorite Api integration
    
    func callingListAllFavoriteApi(){
        MBProgressHUD.showAdded(to: self.view!, animated: true)
        UserManager().getAllFavoriteApi(with: listAllFavoriteRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? ListAllFavoriteResponseModel{
                if model.statusCode == 1{
                   self.favoriteResponseModel = model
                   self.favoriteTableView.reloadData()
                   self.setNoItemsFoundLabel()
                }
                else{
                    self.favoriteResponseModel = nil
                    self.favoriteTableView.reloadData()
                    self.setNoItemsFoundLabel()
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
    
    func listAllFavoriteRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let user = User.getUser() {
            dict.updateValue(user.userId as AnyObject, forKey: "user_id")
        }
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
    func setNoItemsFoundLabel(){
        if let favModel = self.favoriteResponseModel{
            if (favModel.favoriteItems.count != 0){
                self.noItemsFoundLabel.isHidden = true
            }
            else{
                self.noItemsFoundLabel.isHidden = false
            }
        }
        else{
            self.noItemsFoundLabel.isHidden = false
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
