//
//  EventsVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 1/5/19.
//  Copyright © 2019 praveen raj. All rights reserved.
//

import UIKit

class EventsVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchView: UIView!
    
    override func initView() {
        super.initView()
        tableCellRegistration()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func tableCellRegistration(){
        tableView.register(UINib.init(nibName: "EventsTVC", bundle: nil), forCellReuseIdentifier: "eventsCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
    }
    
    @IBAction func searchIconButtonAction(_ sender: UIButton) {
        searchTF.becomeFirstResponder()
    }
    
    //MARK:- Button Actions
    
    @IBAction func actionAdd(_ sender: Any) {
        let vc:AddEventViewController = AddEventViewController(nibName: "AddEventViewController", bundle: nil)
        let navController:UINavigationController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated: false, completion: nil)
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

extension EventsVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EventsVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let eventsCell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath) as! EventsTVC
            return eventsCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
