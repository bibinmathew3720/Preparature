//
//  AddItineraryVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 2/2/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit

class AddItineraryVC: BaseViewController {

    @IBOutlet weak var addItineraryTV: UITableView!
    var landMarks = [AddLandmark]()
    override func initView() {
        super.initView()
        initialisation()
    }
    
    func initialisation(){
        tableCellRegistration()
        addItineraryTV.estimatedRowHeight = 60
        addItineraryTV.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableCellRegistration(){
        addItineraryTV.register(UINib.init(nibName: "AdditineraryTVC", bundle: nil), forCellReuseIdentifier: "addItCell")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addLandMarkButtonAction(_ sender: UIButton) {
        let addLandMark = AddLandmark()
        landMarks.insert(addLandMark, at: 0)
        addItineraryTV.reloadData()
    }
}

extension AddItineraryVC:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return landMarks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addItCell", for: indexPath) as!AdditineraryTVC
        cell.tag = indexPath.section
        cell.delegate = self
        cell.setLandMarkDetails(landMark:landMarks[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}

extension AddItineraryVC:AddItineraryTVCDelegate{
    func textFieldEditeChangedDelegate(tag: Int, textField: UITextField) {
    
    }
}
