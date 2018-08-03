//
//  WebViewVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 8/3/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit
enum PageType {
    case TermsAndCondtions
    case PrivacyPolicy
}

class WebViewVC: BaseViewController {
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var pageType:PageType?
    var settingsResponse:SettingsResponseModel?
    
    override func initView() {
        super.initView()
        initialisation()
    }
    
    func initialisation(){
        if pageType == PageType.TermsAndCondtions {
            self.headingLabel.text = "Terms and Conditions"
            if let response = self.settingsResponse {
                self.contentLabel.text = response.settingItems[1].content
            }
        }
        else if pageType == PageType.PrivacyPolicy{
            self.headingLabel.text = "Privacy Policy"
            if let response = self.settingsResponse {
                self.contentLabel.text = response.settingItems[0].content
            }
        }
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
