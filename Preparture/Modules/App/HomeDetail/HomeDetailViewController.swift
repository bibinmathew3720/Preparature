//
//  HomeDetailViewController.swift
//  Preparture
//
//  Created by praveen raj on 07/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class HomeDetailViewController: BaseViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollFull: UIScrollView!
    @IBOutlet weak var viewScrollFull: UIView!
    @IBOutlet weak var scrollTop: UIScrollView!
    @IBOutlet weak var viewScrollTop: UIView!
    @IBOutlet weak var imageTop: UIImageView!
    @IBOutlet weak var pageControllTop: UIPageControl!
    @IBOutlet weak var labelTopName: UILabel!
    @IBOutlet weak var labelReviewsCount: UILabel!
    @IBOutlet weak var starTopFirst: UIImageView!
    @IBOutlet weak var starTopSecond: UIImageView!
    @IBOutlet weak var starTopThird: UIImageView!
    @IBOutlet weak var starTopFourth: UIImageView!
    @IBOutlet weak var starTopFifth: UIImageView!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelPerDay: UILabel!
    @IBOutlet weak var labelEventName: UILabel!
    @IBOutlet weak var labelEventPlace: UILabel!
    @IBOutlet weak var labelEventDate: UILabel!
    @IBOutlet weak var labelTravelExp: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    @IBOutlet weak var imageReviewer: UIImageView!
    @IBOutlet weak var labelReviewerName: UILabel!
    @IBOutlet weak var labelReviewerDate: UILabel!
    @IBOutlet weak var starReviewerFirst: UIImageView!
    @IBOutlet weak var starReviewerSecond: UIImageView!
    @IBOutlet weak var starReviewerThird: UIImageView!
    @IBOutlet weak var starReviewerFourth: UIImageView!
    @IBOutlet weak var starReviewerFifth: UIImageView!
    @IBOutlet weak var labelReviewComments: UILabel!
    @IBOutlet weak var imageReview: UIImageView!
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    @IBOutlet weak var viewTopStar: UIView!
    @IBOutlet weak var constraintSrollTopWidth: NSLayoutConstraint!
    
    override func initView() {
        super.initView()
        
        customization()
    }
    
    func customization() {
        self.scrollTop.delegate = self
        self.pageControllTop.numberOfPages = colors.count
        for index in 0..<colors.count {
            frame.origin.x = self.scrollTop.frame.size.width * CGFloat(index)
            frame.size = self.scrollTop.frame.size
            
            let subView = UIImageView(frame: frame)
            subView.backgroundColor = colors[index]
            self.viewScrollTop.addSubview(subView)
        }
        self.viewScrollTop.bringSubview(toFront: labelTopName)
        self.viewScrollTop.bringSubview(toFront: pageControllTop)
        self.viewScrollTop.bringSubview(toFront: viewTopStar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.constraintSrollTopWidth.constant = UIScreen.main.bounds.width * CGFloat(colors.count)
    }

    //MARK:- UIScrollView Delegate Methods
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControllTop.currentPage = Int(pageNumber)
    }

    //MARK:- UIView Action Methods
    
    @IBAction func actionPageControllValueChanged(_ sender: UIPageControl) {
        let x = CGFloat(pageControllTop.currentPage) * scrollTop.frame.size.width
        scrollTop.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    @IBAction func actionReadReviews(_ sender: Any) {
        
    }
}
