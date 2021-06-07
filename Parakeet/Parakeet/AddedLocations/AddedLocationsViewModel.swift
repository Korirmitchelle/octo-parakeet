//
//  AddedLocationsViewModel.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 07/06/2021.
//

import Foundation
import RxSwift
import RxCocoa
class AddedLocationsViewModel{
    let locations = BehaviorRelay(value: [Location]())
    
    func fetchSavedLocations() -> Completable {
        Completable.create { [weak self] completable in
            let defaults = UserDefaults.standard
            if let data = defaults.data(forKey: "locations") {
                let array = try! PropertyListDecoder().decode([Location].self, from: data)
                self?.locations.accept(array)
                completable(.completed)
            }
            else{
                completable(.error(ServerError(description: "")))
            }
            return Disposables.create()
        }
    }
    
   
}
