//
//  FeedsVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 5/29/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit

class FeedsVC: BaseViewController {

    override func initView() {
        super.initView()
        //tableCellRegistration()
        //addingRightBarButtonWithImage(buttonImage: "addItem")
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }


    @IBAction func plusButtonAction(_ sender: UIButton) {
        let vc:AddEventViewController = AddEventViewController(nibName: "AddEventViewController", bundle: nil)
        let navController:UINavigationController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
