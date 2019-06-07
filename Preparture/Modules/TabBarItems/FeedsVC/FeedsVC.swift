//
//  FeedsVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 5/29/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit

class FeedsVC: BaseViewController {
    var feedsArray = [Feed]()
    var feedTitle = String()
    var feedLink = String()
    var feedComment = String()
    var feedPubDate = String()
    var feedDescription = String()
    var elementName: String = String()
    var pageIndex:Int = 1
    @IBOutlet weak var feedsTableView: UITableView!
    override func initView() {
        super.initView()
        tableCellRegistration()
        getFeedsData()
        //addingRightBarButtonWithImage(buttonImage: "addItem")
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func getFeedsData(){
        guard var encodedUrlstring = GET_ALL_CHICAGO_FEEDS_URL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
        encodedUrlstring = encodedUrlstring + "\(pageIndex)"
        let requestURL = URL(string: encodedUrlstring)
        if let _url = requestURL{
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                let xmlParser = XMLParser.init(contentsOf: _url)
                if let _xmlParser = xmlParser{
                    _xmlParser.delegate = self
                    _xmlParser.parse()
                }
            }
            
        }
    }
    
    func tableCellRegistration(){
        feedsTableView.register(UINib.init(nibName: "FeedsTVC", bundle: nil), forCellReuseIdentifier: "feedsCell")
    }


    @IBAction func plusButtonAction(_ sender: UIButton) {
        let vc:AddEventViewController = AddEventViewController(nibName: "AddEventViewController", bundle: nil)
        let navController:UINavigationController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated: false, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension FeedsVC:XMLParserDelegate{
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
       // print(elementName)
        if elementName == "item" {
            feedTitle = String()
            feedLink = String()
            feedComment = String()
            feedPubDate = String()
            feedDescription = String()
        }
        else if elementName == "description"{
        }
       self.elementName = elementName
    }
    
    // 2
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let feed = Feed.init(title: feedTitle, link: feedLink, comments: feedComment, date: feedPubDate, feedDes: feedDescription)
            feedsArray.append(feed)
        }
        else if elementName == "channel"{
            feedsTableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //if (!data.isEmpty) {
            if self.elementName == "title" {
                feedTitle += data
            } else if self.elementName == "link" {
                feedLink += data
            }else if self.elementName == "comments" {
                feedComment += data
            }else if self.elementName == "pubDate" {
                feedPubDate += data
            }else if self.elementName == "description" {
                feedDescription += data
            }
        //}
        
    }
}

extension FeedsVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedsCell = tableView.dequeueReusableCell(withIdentifier: "feedsCell", for: indexPath) as! FeedsTVC
        feedsCell.tag = indexPath.row
        feedsCell.setFeed(feed:feedsArray[indexPath.row])
        return feedsCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aspectRatio:CGFloat = 0.5
        return aspectRatio * UIScreen.main.bounds.size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let feedWebViewVC = FeedWebViewVC.init(nibName: "FeedWebViewVC", bundle: nil)
        let feed = feedsArray[indexPath.row]
        feedWebViewVC.urlString = feed.feedLink
        self.navigationController?.pushViewController(feedWebViewVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == (feedsArray.count-1)){
            pageIndex += 1
            self.getFeedsData()
        }
    }
}
