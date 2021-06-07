//
//  LocationsViewController.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 07/06/2021.
//

import UIKit
import RxSwift
import GoogleMaps

class LocationsViewController: UIViewController {
    @IBOutlet weak var switchStackview: UIStackView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var locationsTableview: UITableView!
    @IBOutlet weak var toggleSwitch: UISwitch!
    let viewModel = AddedLocationsViewModel()
    lazy var disposeBag = DisposeBag()
    
    @IBOutlet weak var mapview: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchLocations()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchLocations), name: NSNotification.Name(rawValue: "fetchlocations"), object: nil)
        toggleSwitch.addTarget(self, action: #selector(switchChanaged(mySwitch:)), for: .valueChanged)
    }
    
    @objc func switchChanaged(mySwitch: UISwitch){
        if mySwitch.isOn{
            mapview.isHidden = false
            locationsTableview.isHidden = true
        }
        else{
            mapview.isHidden = true
            locationsTableview.isHidden = false
        }
    }
    
    
    func setupTableView(){
        locationsTableview.delegate = self
        locationsTableview.dataSource = self
        mapview.isHidden = true
    }
    
    func hideTableview(){
        locationsTableview.isHidden = true
        emptyView.isHidden = false
        switchStackview.isHidden = true
    }
    
    func showTableview(){
        locationsTableview.isHidden = false
        emptyView.isHidden = true
        switchStackview.isHidden = false
        
    }
    
    
    @objc func fetchLocations(){
        self.toggleSwitch.isOn = false
        self.viewModel.fetchSavedLocations().subscribe { [weak self] event in
            guard let `self` = self else { return }
            print("coun \(self.viewModel.locations.value.count)")
            if self.viewModel.locations.value .count > 0 {
                self.showTableview()
                self.configuremapView()
            }
            else{
                self.hideTableview()
            }
            self.locationsTableview.reloadData()
            
        }.disposed(by: self.disposeBag)
    }
    
    func configuremapView(){
        var markerList = [GMSMarker]()
        for location in self.viewModel.locations.value {
            let marker = GMSMarker()
            marker.map = self.mapview
            marker.iconView = UIImageView(image: R.image.location())
            marker.position =  CLLocationCoordinate2DMake(location.lat,location.lon)
            markerList.append(marker)
        }
        Utils().delay(seconds: 2) { () -> () in
            //fit map to markers
            var bounds = GMSCoordinateBounds()
            for marker in markerList {
                bounds = bounds.includingCoordinate(marker.position)
            }
            let update = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
            self.mapview.animate(with: update)
        }
    }
    
    
    @IBAction func addLocation(_ sender: Any) {
        guard let addController = R.storyboard.main.addLocationViewController() else {
            return
        }
        self.present(addController, animated: true, completion: nil)
    }
}
extension LocationsViewController:UITableViewDelegate{}
extension LocationsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.locations.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addedcell", for: indexPath) as? AddedLocationTableViewCell else {return UITableViewCell()}
        cell.locationLabel.text = self.viewModel.locations.value[indexPath.row].name
        
        return cell
    }
}
