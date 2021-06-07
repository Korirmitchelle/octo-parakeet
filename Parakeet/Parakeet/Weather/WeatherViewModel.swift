//
//  WeatherViewModel.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 06/06/2021.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class WeatherViewModel{
    lazy var locator = Locator()
    let daysOfWeek = BehaviorRelay(value: [String]())
    let disposeBag = DisposeBag()


    func getWeekdays() {
        self.daysOfWeek.accept(Date().getDays())
    }
    
    
    func findMe() -> Single<Result>{
        self.locator.findMe()
        return Single.create { single -> Disposable in
            self.locator.onAcquireLocation = { location in
                self.getWeather(location: location).subscribe(onSuccess: {result in
                    single(.success(result))
                }, onFailure: {
                    (error) in
                    single(.failure(ServerError(description: error.localizedDescription)))
                }).disposed(by: self.disposeBag)
            }
            return Disposables.create()
        }
    }
    
    
    func getWeather(location:CLLocationCoordinate2D) -> Single<Result> {
        return Single.create { single -> Disposable in
                NetworkService.shared.setLatitude(location.latitude)
                NetworkService.shared.setLongitude(location.longitude)
                NetworkService.shared.getWeather(onSuccess: { (result) in
                    var mutatingResult = result
                    mutatingResult.sortDailyArray()
                    mutatingResult.sortHourlyArray()
                    single(.success(mutatingResult))
                }) { (errorMessage) in
                    debugPrint(errorMessage)
                    single(.failure(ServerError(description: errorMessage)))
                }
            
            return Disposables.create()
        }
    }

    
    func saveLocation(location:Location) -> Completable{
        Completable.create { completable in
            let defaults = UserDefaults.standard
            if let data = defaults.data(forKey: "locations") {
                let array = try! PropertyListDecoder().decode([Location].self, from: data)
                var savedMutable = array
                savedMutable.append(location)
                if let data = try? PropertyListEncoder().encode(savedMutable) {
                    UserDefaults.standard.set(data, forKey: "locations")
                    completable(.completed)
                }
            }
            else{
                var array = [Location]()
                array.append(location)
                if let data = try? PropertyListEncoder().encode(array) {
                    defaults.set(data, forKey: "locations")
                    completable(.completed)
                }
            }
            return Disposables.create()
        }
        
    }
    
}
