//
//  HomeListCVC.swift
//  Preparture
//
//  Created by Bibin Mathew on 7/4/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

protocol HomeListTVDelegate: class {
    func selectedCellDelegateWithTag(tag:NSInteger)
    func addToFavoriteFromClick(suggestion:SuggestionItems)
}

class HomeListCVC: UICollectionViewCell,UITableViewDataSource,UITableViewDelegate,HomeListTVCDelegate {
    @IBOutlet weak var tableView: UITableView!
    weak var delegate : HomeListTVDelegate?
    var suggestionsArray:[SuggestionItems]?
    override func awakeFromNib() {
        super.awakeFromNib()
        tableCellRegistration()
        // Initialization code
    }
    
    func tableCellRegistration(){
        tableView.register(UINib.init(nibName: "HomeListTVC", bundle: nil), forCellReuseIdentifier: "homeListCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sugArray = self.suggestionsArray{
            return sugArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeListCell", for: indexPath) as!HomeListTVC
        if let sugArray = self.suggestionsArray{
            cell.setSuggestionItem(suggestion:sugArray[indexPath.row])
        }
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCellDelegateWithTag(tag: indexPath.row)
    }
    
    func setSuggestionArray(sugArray:[SuggestionItems]){
        self.suggestionsArray = sugArray
        self.tableView.reloadData()
    }
    
    //MARK:- HomeListTVC Delegate method
    
    func addToFavorite(tag:NSInteger) {
        delegate?.addToFavoriteFromClick(suggestion:self.suggestionsArray![tag])
    }
}
