//
//  PaymentVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 11/13/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class PaymentVC: BaseViewController,UIWebViewDelegate {
    @IBOutlet weak var paymentWebview: UIWebView!
    
    override func initView() {
        super.initView()
        initialisation()
    }
    
    func initialisation(){
        let url = URL (string: "https://paypalmerchant.herokuapp.com/cart");
        let requestObj = URLRequest(url: url!);
        paymentWebview.delegate = self
       // instance.setWebView(ppwbeview);
        paymentWebview.loadRequest(requestObj);
        
        let paypalCheckOut = PYPLCheckout()
        paypalCheckOut.webBrowserOnlyMode = true
        paypalCheckOut.interceptWebView(paymentWebview, withDelegate: self)
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
