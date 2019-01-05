//
//  FavoritesVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 7/4/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class FavoritesVC: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var favoriteTableView: UITableView!
    var favoriteResponseModel:ListAllFavoriteResponseModel?
    override func initView() {
        super.initView()
        tableCellRegistration()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
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
    
    func listAllFavoriteRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        if let user = User.getUser() {
            dict.updateValue(user.userId as AnyObject, forKey: "user_id")
        }
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
