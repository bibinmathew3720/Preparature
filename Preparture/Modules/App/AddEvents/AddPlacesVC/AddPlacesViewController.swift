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
        viewController.dismiss(animated: true, completion: nil)
        print("Place name \(place.name)")
        //placeNameLabel.text = place.name
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
    }

}
