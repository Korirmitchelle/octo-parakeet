//
//  ViewController.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 06/06/2021.
//

import UIKit
import RxSwift


class WeatherViewController: UIViewController {
    @IBOutlet weak var imageview: UIImageView!
    let viewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.getWeather().subscribe(onSuccess: { [weak self] result in
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                
            }
        }, onFailure: { (error) in
            if let serverError = error as? ServerError {
                DispatchQueue.main.async {
//                    self.showAlert(title: "", message: serverError.description)
                }
            }
        }).disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }


}

