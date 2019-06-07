//
//  FeedWebViewVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 6/7/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit

class FeedWebViewVC: BaseViewController {
    @IBOutlet weak var webView: UIWebView!
    var urlString:String = ""
    override func initView() {
        super.initView()
        initialisation()
        //addingRightBarButtonWithImage(buttonImage: "addItem")
        // Do any additional setup after loading the view.
    }
    
    func initialisation(){
        guard let encodedUrlstring = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
        if let url = URL (string:encodedUrlstring){
            let urlRequest:URLRequest = URLRequest(url:url)
            self.webView.loadRequest(urlRequest)
        }
    }


    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

extension FeedWebViewVC:UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        //MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
       // MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        //MBProgressHUD.hide(for: self.view, animated: true)
    }
}
