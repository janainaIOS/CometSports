//
//  Date+Extra.swift
//  Comet Sports
//
//  Created by iosDev on 06/03/2024.
//

import Foundation

extension Date {
    var nextDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    func findDate(duration: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: duration, to: self)!
    }
    
    func numOfDaysFromToday() -> Int {
        return Calendar.current.dateComponents([.day], from: Date(), to: self).day ?? 0
    }
    
    func formatDate(outputFormat: dateFormat)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat.rawValue
        //dateFormatterGet.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: selectedLang == .en ? "en" : "zh-Hans")
        return dateFormatter.string(from: self)
    }
    
    func getRecentDates(isPast:Bool,limit:Int,includeToday: Bool = false) -> [String] {
        let calendar = Calendar.current as NSCalendar
        var dates = [String]()
        if isPast {
            for i in -limit ... -1 {
                let dt = calendar.date(byAdding: .day, value: i, to: self, options: [])!
                let date = dt.formatDate(outputFormat: dateFormat.ddMMyyyy)
                dates.append(date)
            }
            dates = dates.reversed()
        } else {
            let startLimit = includeToday ? 0 : 1
            for i in startLimit...limit { // Make 0 -> 1 to exclude "date"
                let dt = calendar.date(byAdding: .day, value: i, to: self, options: [])!
                let date = dt.formatDate(outputFormat: dateFormat.ddMMyyyy)
                dates.append(date)
            }
        }
        return dates
    }
}
