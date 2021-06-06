//
//  Locator.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 06/06/2021.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

class Locator: NSObject {
    var onAcquireLocation: ((CLLocationCoordinate2D) -> Void)?

    // MARK: - State
    let manager: CLLocationManager
    
    // MARK: - Initialization
    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
    }
    
    // MARK: - Functions
    func findMe() {
        self.manager.requestWhenInUseAuthorization()
        self.manager.delegate = self
    }
}
// MARK: - Location manager delegate
extension Locator: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last,let handler = self.onAcquireLocation else{return}
        AppConstants.location = location.coordinate
        manager.stopUpdatingLocation()
        handler(location.coordinate)
    }
}
