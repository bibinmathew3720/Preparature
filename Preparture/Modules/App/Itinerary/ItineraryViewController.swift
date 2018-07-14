//
//  ItineraryViewController.swift
//  Preparture
//
//  Created by praveen raj on 07/07/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class ItineraryViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableViewHeightCnstraint: NSLayoutConstraint!
    @IBOutlet weak var placesTableView: UITableView!
    var cellHeight:CGFloat = 100
    override func initView() {
        super.initView()
        customization()
    }
    
    func customization() {
       self.addShadowToAView(shadowView: self.scrollView)
        tableViewHeightCnstraint.constant = 20.0*cellHeight
        tableCellRegistration()
        
    }
    
    func tableCellRegistration(){
        placesTableView.register(UINib.init(nibName: "ItineraryTVC", bundle: nil), forCellReuseIdentifier: "itinararyCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itinararyCell", for: indexPath) as!ItineraryTVC
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
