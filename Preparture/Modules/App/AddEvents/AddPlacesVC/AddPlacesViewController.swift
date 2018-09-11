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

class AddPlacesViewController: BaseViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    var locationMarker:GMSMarker!
    let locationMgr = CLLocationManager()
    var userLocLatitude = 0.000000
    var userLocLongitude = 0.00000
    
    override func initView() {
        super.initView()
        
        customization()
    }
    
    func customization() {
        getLocation()
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
    
}


extension AddPlacesViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation:CLLocation = locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude), zoom: 17.5)
        
        self.mapView?.animate(to: camera)
        locationMgr.stopUpdatingLocation()
        let position = currentLocation.coordinate
        let marker = GMSMarker(position: position)
        marker.title = "wewl"
        marker.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
