//
//  ViewController.swift
//  MKMapView
//
//  Created by PHN MAC 1 on 18/10/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfiguration()
    }
    
    
}

// MARK: - UIConfigurations
extension ViewController{
    private func uiConfiguration(){
        //set mapView
        mapView.showsUserLocation = true
        
        //configure location manager
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            }
        }
    }
}

// MARK: - CLLocation Manager Delegate
extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let currentLocation = location.coordinate
            let region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            
            mapView.setRegion(region, animated: true)
            
            // Add a pin (annotation) to mark the current location
            let annotation = MKPointAnnotation()
            annotation.coordinate = currentLocation
            annotation.title = "Current Location"
            
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(annotation)
            
            // Stop updating location to save battery life
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
