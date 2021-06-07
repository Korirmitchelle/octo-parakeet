//
//  LocationsViewController.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 07/06/2021.
//

import UIKit

class LocationsViewController: UIViewController {
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var locationsTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationsTableview.isHidden = true

    }
    @IBAction func addLocation(_ sender: Any) {
        guard let addController = R.storyboard.main.addLocationViewController() else {
            return
        }
        self.present(addController, animated: true, completion: nil)
    }
    

}
