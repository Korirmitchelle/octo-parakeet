//
//  TabBarViewController.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 07/06/2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    @IBOutlet weak var customTabbar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTabbar.barTintColor = .white
        customTabbar.tintColor = .black

    }
    

}
