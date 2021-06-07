//
//  AddLocationViewModel.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 07/06/2021.
//

import Foundation
import RxSwift
import RxCocoa

class AddLocationViewModel {
    let disposeBag = DisposeBag()
    let places = BehaviorRelay(value: [Location]())
    let reloadData = BehaviorRelay<Bool>(value: true)
    
    func loadPlaces(query: String) {
        guard query.count > 2 else {
            return
        }
        self.places.accept([Location]())
        NetworkService.shared.getPlaces(searchString: query).subscribe(onSuccess: { [weak self] result in
            DispatchQueue.main.async {
                self?.getCoordinates(predictions: result.predictions)
            }
        }, onFailure: {
            (error) in
        }).disposed(by: disposeBag)
        
        
    }
    
    func getCoordinates(predictions:[Prediction]){
        predictions.forEach {prediction in
            NetworkService.shared.getCoordinates1(prediction: prediction).subscribe(onSuccess: { [weak self] location in
                self?.places.add(element: location)
                self?.reloadData.accept(true)
            }, onFailure: {
                (error) in
            }).disposed(by: disposeBag)
        }
        
    }
    

}

extension BehaviorRelay where Element: RangeReplaceableCollection {
    
    func add(element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
}
