//
//  Model.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 06/06/2021.
//
import UIKit
import Foundation

struct Result: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let current: Current
    var hourly: [Hourly]
    var daily: [Daily]
    
    mutating func sortHourlyArray() {
        hourly.sort { (hour1: Hourly, hour2: Hourly) -> Bool in
            return hour1.dt < hour2.dt
        }
    }
    
    mutating func sortDailyArray() {
        daily.sort { (day1, day2) -> Bool in
            return day1.dt < day2.dt
        }
    }
}

struct Current: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let uvi: Double
    let clouds: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let clouds: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Weather]
}

struct Daily: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Temperature
    let feels_like: Feels_Like
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Weather]
    let clouds: Int
    let uvi: Double
}

struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct Feels_Like: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}

enum WeatherType:String{
    case sunny = "Sun"
    case rainy = "Rain"
    case clouds = "Clouds"
    
    var background: UIImage? {
        switch self {
        case .sunny: return R.image.sunny()
        case .rainy: return R.image.rainy()
        case .clouds: return R.image.cloudy()
        }
    }
    var title: String? {
        switch self {
        case .sunny: return R.string.localizable.weatherSunny()
        case .rainy: return R.string.localizable.weatherRainy()
        case .clouds : return R.string.localizable.weatherCloudy()
        }
    }
    var color: UIColor? {
        switch self {
        case .sunny: return .sunny
        case .rainy: return .rainy
        case .clouds: return .cloudy
        }
    }
}
