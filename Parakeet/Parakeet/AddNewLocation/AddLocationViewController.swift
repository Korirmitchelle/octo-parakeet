//
//  AddLocationViewController.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 07/06/2021.
//

import UIKit
import GoogleMaps
import RxSwift

class AddLocationViewController: UIViewController {
    
    let distanceSpan: Double = 5000
    var lastLocation:CLLocation?
    private let disposeBag = DisposeBag()
    var locationManager: CLLocationManager?

    @IBOutlet weak var locationTableview: UITableView!
    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var locationPinImageview: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let viewModel = AddLocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        locationTableview.isHidden = true
        setUpObservables()
        if let locationManager = self.locationManager {
            locationManager.delegate = self
            mapView.delegate = self
            locationManager.desiredAccuracy = .leastNormalMagnitude
            locationManager.requestAlwaysAuthorization()
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func done(_ sender: Any) {
    
    }
    
    func setUpObservables(){
        locationTextfield.rx.text.orEmpty.subscribe(onNext: { [weak self] query in
            guard let self = self else { return }
            self.viewModel.loadPlaces(query: query)
        }).disposed(by: disposeBag)
    }
    
}

extension AddLocationViewController:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let coordinate = mapView.projection.coordinate(for: mapView.center)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        location.geocode(completion: {place,error in
                        self.locationTextfield.text = place?.first?.locality
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    })
        self.lastLocation = location

    }
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
}
extension AddLocationViewController:CLLocationManagerDelegate{
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            AppConstants.location = location.coordinate
            locationManager?.stopUpdatingLocation()
            let currentCamera = GMSCameraPosition(target: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
            self.mapView.camera = currentCamera
        }
    }
}


extension CLLocation {
    func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
}
