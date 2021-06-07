//
//  LocationsViewController.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 07/06/2021.
//

import UIKit
import RxSwift

class LocationsViewController: UIViewController {
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var locationsTableview: UITableView!
    let viewModel = AddedLocationsViewModel()
    lazy var disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchLocations()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchLocations), name: NSNotification.Name(rawValue: "fetchlocations"), object: nil)
    }
    
    
    func setupTableView(){
        locationsTableview.delegate = self
        locationsTableview.dataSource = self
    }
    
    func hideTableview(){
        locationsTableview.isHidden = true
        emptyView.isHidden = false
    }
    
    func showTableview(){
        locationsTableview.isHidden = false
        emptyView.isHidden = true
    }

    
   @objc func fetchLocations(){
        self.viewModel.fetchSavedLocations().subscribe { [weak self] event in
            guard let `self` = self else { return }
            self.viewModel.locations.value.isEmpty ? self.hideTableview() : self.showTableview()
            self.locationsTableview.reloadData()
           
        }.disposed(by: self.disposeBag)
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
