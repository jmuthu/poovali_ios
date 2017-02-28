//
//  DateExtensions.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import Foundation

extension Date {
    func getStartOfDay() -> Date {
        var dc: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        dc.hour = 0
        dc.minute = 0
        dc.second = 0
        dc.nanosecond = 0
        dc.timeZone = TimeZone(secondsFromGMT: 0)
        return Calendar.current.date(from: dc)!
    }
    
    public static func daysBetween(fromDate: Date, toDate: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
    }
    
    public func add(days:Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}
