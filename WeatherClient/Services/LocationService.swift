//
//  LocationService.swift
//  WeatherClient
//
//  Created by Anhquan Nguyen on 8/10/19.
//  Copyright © 2019 Anhquan Nguyen. All rights reserved.
//

import UIKit
import CoreLocation

class LocationService: NSObject {
    var newestLocation: ((CLLocationCoordinate2D?) -> Void)?
    var statusUpdated: ((CLAuthorizationStatus) -> Void)?
    let manager: CLLocationManager
    
    var status: CLAuthorizationStatus{
        return CLLocationManager.authorizationStatus()
    }
    
    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        
        // initialize NS object
        super.init()
        
        manager.delegate = self
    }
    
    func getPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func getLocation() {
        manager.requestLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.sorted(by: { $0.timestamp > $1.timestamp}).first {
            self.newestLocation?(location.coordinate)
        }
        else {
            self.newestLocation?(nil)
        }
    }
    
    // Error detection
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get the user location: \(error.localizedDescription)")
    }
    // Give permissions for location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location status: \(status)")
    }
}
