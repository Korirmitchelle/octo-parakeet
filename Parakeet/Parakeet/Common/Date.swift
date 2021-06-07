//
//  Date.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 06/06/2021.
//

import Foundation

extension Date {
    
    func getDays() -> [String]{
        var weekDays = [String]()
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        for _ in 1 ... 8 {
            date = cal.date(byAdding: .day, value: 1, to: date)!
            let formatter = DateFormatter()
            formatter.dateFormat = "eeee"
            weekDays.append(formatter.string(from: date))
        }
        return weekDays
    }
    
}
