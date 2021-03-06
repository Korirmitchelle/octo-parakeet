//
//  ViewController.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 06/06/2021.
//

import UIKit
import RxSwift
import Rswift
import GoogleMaps

class WeatherViewController: UIViewController {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherDetailsView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minimumLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var maximumLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    
    var results:Result?
    let viewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()
    var location:Location?
    var city = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        fetchForecast()
        setupTableview()
        viewModel.getWeekdays()
        saveButton.isHidden = location == nil
        saveButton.addTarget(self, action: #selector(saveLocation), for: .touchUpInside)
    }
    
    
    @objc func saveLocation(){
        guard let location = location else {
            return
        }
        self.viewModel.saveLocation(location: location).subscribe { [weak self] event in
            guard let `self` = self else { return }
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: "fetchlocations"),
                object: nil)
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
           
        }.disposed(by: self.disposeBag)
    }
    
    func setupTableview(){
        weatherTableView.separatorStyle = .none
        weatherTableView.dataSource = self
        
    }
    
    func fetchForecast(){
        guard let location = location else {
            findMe()
            return
        }
        getWeather(location: CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon))
    }
    
    func findMe(){
        self.viewModel.findMe().subscribe(onSuccess: { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.showViews(result: result)
            }
        }, onFailure: { (error) in
            
        }).disposed(by: disposeBag)
    }
    
    func getWeather(location:CLLocationCoordinate2D){
        
        self.viewModel.getWeather(location: location).subscribe(onSuccess: { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.showViews(result: result)
            }
        }, onFailure: { (error) in
            
        }).disposed(by: disposeBag)
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
        self.results = result
        weatherTableView.reloadData()
        let dayTemp = result.daily[0].temp.day
        self.locationLabel.text = city
        self.temperatureLabel.text = "\(dayTemp)"
        let mainDescription = result.current.weather[0].main
        self.minimumLabel.text = String(result.daily[0].temp.min)
        self.currentLabel.text = String(dayTemp)
        self.maximumLabel.text = String(result.daily[0].temp.max)
        let type = WeatherType(rawValue: mainDescription) ?? .clouds
        self.changeColors(type: type)
    }
    
    func changeColors(type:WeatherType){
        self.weatherLabel.text = type.title?.uppercased()
        self.imageview.image = type.backgroundImage
        self.weatherTableView.backgroundColor = type.color
        self.weatherDetailsView.backgroundColor = type.color
    }
}

extension WeatherViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dailyResults = results?.daily{
            return dailyResults.count - 1
        }
        else{
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "daycell", for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()}
        if let main = results?.daily[indexPath.row + 1].weather[0].main {
            let type = WeatherType(rawValue:main)
            cell.dayImageview.image = type?.icon
        }
        if let temperature = results?.daily[indexPath.row + 1].temp.day{
            cell.temperatureLabel.text = String(temperature)
        }
        let isIndexValid = viewModel.daysOfWeek.value.indices.contains(indexPath.row)
        if isIndexValid{
            cell.dayLabel.text = viewModel.daysOfWeek.value[indexPath.row]
        }
        
        return cell
    }
}
