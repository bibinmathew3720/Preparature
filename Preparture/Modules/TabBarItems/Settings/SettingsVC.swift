//
//  SettingsVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 7/4/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class SettingsVC: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var settingsTableView: UITableView!
    let generalArray = ["General"," Notification","Feed back","Rate & Review","Terms & Conditions"]
    let generalImagesArray = [#imageLiteral(resourceName: "notification"),#imageLiteral(resourceName: "notification"),#imageLiteral(resourceName: "feedback"),#imageLiteral(resourceName: "rateAndReview"),#imageLiteral(resourceName: "terms")]
    let accountsArray = ["Account"," Change Password", "Edit Profile", "Log out"]
    let accountImagesArray = [#imageLiteral(resourceName: "changePassword"),#imageLiteral(resourceName: "changePassword"),#imageLiteral(resourceName: "editIcon"),#imageLiteral(resourceName: "logout")]
    let sectionHeaderheight = 50
    override func initView() {
        super.initView()
        tableCellRegistration()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func tableCellRegistration(){
        settingsTableView.register(UINib.init(nibName: "SettingsHeaderTVC", bundle: nil), forCellReuseIdentifier: "settingHeader")
        settingsTableView.register(UINib.init(nibName: "SettingsTVC", bundle: nil), forCellReuseIdentifier: "settingCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.generalArray.count
        }
        else{
           return self.accountsArray .count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let settingHeaderCell = tableView.dequeueReusableCell(withIdentifier: "settingHeader", for: indexPath) as! SettingsHeaderTVC
            if indexPath.section == 0{
                settingHeaderCell.headerLabel.text = self.generalArray.first
            }
            else{
                settingHeaderCell.headerLabel.text = self.accountsArray.first
            }
            return settingHeaderCell
        }
        else{
            let settingCell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingsTVC
            if indexPath.section == 0{
                settingCell.settingLabel.text = self.generalArray[indexPath.row]
                settingCell.settingsIcon.image = self.generalImagesArray[indexPath.row]
            }
            else{
                settingCell.settingLabel.text = self.accountsArray[indexPath.row]
                settingCell.settingsIcon.image = self.accountImagesArray[indexPath.row]
            }
            return settingCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return CGFloat(sectionHeaderheight)
        }
        else{
            return (self.view.frame.size.height - 120-2*CGFloat(sectionHeaderheight))/6
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            
        } else if indexPath.section == 1{
            if indexPath.row == 1 {
                let changePswd = ChangePswdViewController(nibName: "ChangePswdViewController", bundle: nil)
                self.present(changePswd, animated: true, completion: nil)
            } else if indexPath.row == 2 {
                let editProfile = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
                self.present(editProfile, animated: true, completion: nil)
            }
            else if indexPath.row == 3 {
               showAlertForLogout()
            }
        }
    }
    
    func showAlertForLogout() {
        let alertController = UIAlertController(title: Constant.AppName, message: "Do you want to Logout?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title:"YES", style: .default) { (action:UIAlertAction) in
            CCUtility.processAfterLogOut()
        }
        let noAction = UIAlertAction(title:"NO", style: .default) { (action:UIAlertAction) in
            
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true) {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
