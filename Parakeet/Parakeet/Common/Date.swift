//
//  Date.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 06/06/2021.
//

import Foundation

extension Date {
    func dayOfWeek() -> Int? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        return calendar.dateComponents([.day], from: self).weekday
    }
}
