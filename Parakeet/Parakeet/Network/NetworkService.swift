//
//  NetworkService.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 06/06/2021.
//

import Foundation
import GooglePlaces
import RxSwift

class NetworkService {
    static let shared = NetworkService()
    let URL_API_KEY = "76206cd3a7796e7db880c8385c0786ef"
    var URL_LATITUDE = "60.99"
    var URL_LONGITUDE = "30.0"
    var URL_GET_ONE_CALL = ""
    let URL_BASE = "https://api.openweathermap.org/data/2.5"
    let session = URLSession(configuration: .default)
    
    func buildURL() -> String {
        URL_GET_ONE_CALL = "/onecall?lat=" + URL_LATITUDE + "&lon=" + URL_LONGITUDE + "&units=imperial" + "&appid=" + URL_API_KEY
        return URL_BASE + URL_GET_ONE_CALL
    }
    
    func setLatitude(_ latitude: String) {
        URL_LATITUDE = latitude
    }
    
    func setLatitude(_ latitude: Double) {
        setLatitude(String(latitude))
    }
    
    
    func setLongitude(_ longitude: String) {
        URL_LONGITUDE = longitude
    }
    
    func setLongitude(_ longitude: Double) {
        setLongitude(String(longitude))
    }
    
    func getWeather(onSuccess: @escaping (Result) -> Void, onError: @escaping (String) -> Void) {
        guard let url = URL(string: buildURL()) else {
            onError("Error building URL")
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                do {
                    if response.statusCode == 200 {
                        let items = try JSONDecoder().decode(Result.self, from: data)
                        onSuccess(items)
                    } else {
                        onError("Response wasn't 200. It was: " + "\n\(response.statusCode)")
                    }
                } catch {
                    onError(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func getPlaces(searchString: String) -> Single<Locations> {
        let params = [
            "input": searchString,
            "types": "",
            "key": AppConstants.googleMapsKey,
            "location": "\(AppConstants.location.latitude),\(AppConstants.location.longitude)",
            "radius": 100.description
        ]
        return doRequest(
            url: "https://maps.googleapis.com/maps/api/place/autocomplete/json",
            params: params
        )
    }
    
    func doRequest(url: String, params: [String: String] ) -> Single<Locations> {
        return Single.create { completable -> Disposable in
            let request = NSMutableURLRequest(
                url: NSURL(string: "\(url)?\(self.query(parameters: params as [String: AnyObject]))")! as URL
            )
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil , let data = data else {
                    completable(.failure(ServerError(description: error?.localizedDescription ?? "")))
                    return
                }
                do {
                    let items = try JSONDecoder().decode(Locations.self, from: data)
                    completable(.success(items))
                    
                } catch {
                    print("error here \(error)")
                    completable(.failure(ServerError(description: error.localizedDescription)))
                }
                
            }
            task.resume()
            return Disposables.create()
        }
    }
    
    
    func query(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sorted(by: <) {
            let value: AnyObject = parameters[key]!
            components += [(escape(string: key), escape(string: "\(value)"))]
        }
        
        return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
    }
    
    func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: NSCharacterSet = NSCharacterSet(charactersIn: ":/?&=;+!@#$()',*") as NSCharacterSet
        return NSString(string: string).addingPercentEncoding(withAllowedCharacters: legalURLCharactersToBeEscaped as CharacterSet)! as String
    }
    
    
    func getCoordinates(predictions:[Prediction] )-> [Location] {
        var locations = [Location]()
        for prediction in predictions {
            GMSPlacesClient.shared().lookUpPlaceID(prediction.placeID) { results, error in
                guard error == nil, let results = results else {
                    return
                }
                let location = Location(name: (prediction.structuredFormatting.mainText ?? results.name) ?? "", detail: (prediction.structuredFormatting.secondaryText ?? results.formattedAddress) ?? "", id: prediction.placeID, lat: results.coordinate.latitude, lon: results.coordinate.longitude)
                locations.append(location)
            }
        }
//        return Single.create { single in
//            var locations = [Location]()
//            for prediction in predictions {
//                GMSPlacesClient.shared().lookUpPlaceID(prediction.placeID) { results, error in
//                    guard error == nil, let results = results else {
//                        single(.failure(error ?? ServerError(description: "Invalid response")))
//                        return
//                    }
//                    let location = Location(name: prediction.structuredFormatting.mainText, detail: prediction.structuredFormatting.secondaryText, id: prediction.placeID, lat: results.coordinate.latitude, lon: results.coordinate.longitude)
//                    locations.append(location)
//                    single(.success(locations))
//                }
//            }
//            return Disposables.create()
//        }
        return locations
    }
    
    
    func getCoordinates1(prediction:Prediction)-> Single<Location> {
        return Single.create { single in
            GMSPlacesClient.shared().lookUpPlaceID(prediction.placeID) { results, error in
                guard error == nil, let results = results else {
                    single(.failure(error ?? ServerError(description: "Invalid response")))
                    return
                }
                let location = Location(name: (prediction.structuredFormatting.mainText ?? results.name) ?? "", detail: (prediction.structuredFormatting.secondaryText ?? results.formattedAddress) ?? "", id: prediction.placeID, lat: results.coordinate.latitude, lon: results.coordinate.longitude)
                single(.success(location))
                
            }
            return Disposables.create()
        }
    }
}
