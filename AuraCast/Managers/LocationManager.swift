//
//  LocationManager.swift
//  AuraCast
//
//  Created by Mihail Verejan on 20.07.2025.
//


import Foundation
import CoreLocation


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        isLoading = true
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        isLoading = false
        
        // Post notification when location is updated
        NotificationCenter.default.post(name: Notification.Name("LocationUpdated"), object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        // If authorization was just granted, request location immediately
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        }
        
        // Post notification about authorization change
        NotificationCenter.default.post(name: Notification.Name("LocationAuthorizationChanged"), object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Failed to get location: \(error.localizedDescription)")
        isLoading = false
    }
}
