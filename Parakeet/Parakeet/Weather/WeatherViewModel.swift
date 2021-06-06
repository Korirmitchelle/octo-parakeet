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
    
    func getWeather() -> Single<Result>{
        self.locator.findMe()
        return Single.create { single -> Disposable in
            self.locator.onAcquireLocation = { location in
                NetworkService.shared.setLatitude(location.latitude)
                NetworkService.shared.setLongitude(location.longitude)
                NetworkService.shared.getWeather(onSuccess: { (result) in
                    print("weather result here \(result)")
                    single(.success(result))
                }) { (errorMessage) in
                    debugPrint(errorMessage)
                    single(.failure(ServerError(description: errorMessage)))
                }
            }
            return Disposables.create()
        }
    }
    
}
