//
//  AddPlacesViewController.swift
//  Preparture
//
//  Created by Nimmy K Das on 8/14/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

protocol AddPlacesVCDelegate{
    func selectedLocationDelegate(location:GMSPlace)
    func selectedLocationDelegateWithMarker(location:GMSMarker)
}

class AddPlacesViewController: BaseViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    var locationMarker:GMSMarker!
    let locationMgr = CLLocationManager()
    var userLocLatitude = 0.000000
    var userLocLongitude = 0.00000
    @IBOutlet weak var viewPlaces: UIView!
    @IBOutlet weak var imgvwPlaces: UIImageView!
    @IBOutlet weak var tableViewPlaces: UITableView!
    var arrayPlaces:NSMutableArray = NSMutableArray()
    @IBOutlet weak var labelNoPlaces: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    var delegate:AddPlacesVCDelegate?
    
    override func initView() {
        super.initView()
        
        customization()
    }
    
    func customization() {
        getLocation()
        registerCell()
    }

    
    // MARK:- Get location
    
    func getLocation() {
        let status  = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationMgr.requestWhenInUseAuthorization()
            //return
        }
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        locationMgr.delegate = self
        locationMgr.startUpdatingLocation()
    }
    
    //MARK:- Register cells
    
    func registerCell() {
        tableViewPlaces.register(UINib.init(nibName: "AddPlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "addPlacesTableViewCell")
    }
    
    //MARK:- UIView action methods
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionPlacesShow(_ sender: Any) {
        if viewPlaces.frame.origin.y == UIScreen.main.bounds.size.height - 50 {
            viewPlaces.frame = CGRect(x: 0, y: viewPlaces.frame.origin.y, width: viewPlaces.frame.size.width, height: viewPlaces.frame.size.height)
            UIView.animate(withDuration: 0.4, animations: {
                self.viewPlaces.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - self.viewPlaces.frame.size.height, width: self.viewPlaces.frame.size.width, height: self.viewPlaces.frame.size.height)
            }) { (isCompleted) in
                
            }
        } else {
            self.viewPlaces.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - self.viewPlaces.frame.size.height, width: self.viewPlaces.frame.size.width, height: self.viewPlaces.frame.size.height)
            UIView.animate(withDuration: 0.4, animations: {
                self.viewPlaces.frame = CGRect(x: 0, y: self.viewBottom.frame.origin.y, width: self.viewPlaces.frame.size.width, height: self.viewPlaces.frame.size.height)
            }) { (isCompleted) in
                
            }
        }
    }
}


extension AddPlacesViewController:CLLocationManagerDelegate, GMSPlacePickerViewControllerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation:CLLocation = locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude), zoom: 17.5)
        
        self.mapView?.animate(to: camera)
        locationMgr.stopUpdatingLocation()
        let position = currentLocation.coordinate
        let marker = GMSMarker(position: position)
        marker.title = "I am here"
        marker.map = mapView
        showMarkers(currentLocation: currentLocation)
    }
    
    func showMarkers(currentLocation:CLLocation) {
        let center = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        print("Place name \(place.name)")
        arrayPlaces.add(place)
        if !labelNoPlaces.isHidden {
            labelNoPlaces.isHidden = true
            tableViewPlaces.isHidden = false
        }
        tableViewPlaces.reloadData()
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D) {
        let infoMarker = GMSMarker()
        infoMarker.snippet = placeID
        infoMarker.position = location
        infoMarker.title = name
        infoMarker.opacity = 0;
        infoMarker.infoWindowAnchor.y = 1
        infoMarker.map = mapView
        mapView.selectedMarker = infoMarker
        arrayPlaces.add(infoMarker)
        if !labelNoPlaces.isHidden {
            labelNoPlaces.isHidden = true
            tableViewPlaces.isHidden = false
        }
        tableViewPlaces.reloadData()
    }

}

extension AddPlacesViewController:UITableViewDelegate, UITableViewDataSource, AddPlacesTableViewCellDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addPlacesTableViewCell", for: indexPath) as! AddPlacesTableViewCell
        cell.tag = indexPath.row
        cell.delegate = self
        cell.setModel(model: arrayPlaces[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = arrayPlaces[indexPath.row]
        if let _delegate = delegate{
            if let _location = location as? GMSPlace{
                self.navigationController?.popViewController(animated: true)
                _delegate.selectedLocationDelegate(location: _location)
                return
            }
            if let _location = location as? GMSMarker{
                self.navigationController?.popViewController(animated: true)
                _delegate.selectedLocationDelegateWithMarker(location: _location)
                return
            }
        }
    }
    
    //MARK:- AddPlacesTableViewCellDelegate method
    
    func closeAction(cell:AddPlacesTableViewCell, tag:Int) {
        arrayPlaces.removeObject(at: tag)
        tableViewPlaces.reloadData()
        if arrayPlaces.count == 0 {
            labelNoPlaces.isHidden = false
            tableViewPlaces.isHidden = true
        }
    }
}
