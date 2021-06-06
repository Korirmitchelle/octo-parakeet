//
//  ViewController.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 06/06/2021.
//

import UIKit
import RxSwift


class WeatherViewController: UIViewController {
    @IBOutlet weak var weatherDetailsView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minimumLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var maximumLabel: UILabel!
    
    let viewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        self.viewModel.getWeather().subscribe(onSuccess: { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.showViews(result: result)
                
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
    
    func hideLoadingView(){
        activityIndicator.isHidden = true
        imageview.isHidden = false
        weatherDetailsView.isHidden = false
    }
    
    func showLoadingView(){
        activityIndicator.isHidden = false
        imageview.isHidden = true
        weatherDetailsView.isHidden = true
    }

    
    func showViews(result:Result){
        hideLoadingView()
        let dayTemp = result.daily[0].temp.day
        self.temperatureLabel.text = "\(dayTemp)"
        self.weatherLabel.text = result.current.weather[0].description.uppercased()
        self.minimumLabel.text = String(result.daily[0].temp.min)
        self.currentLabel.text = String(dayTemp)
        self.maximumLabel.text = String(result.daily[0].temp.max)

    }


}

