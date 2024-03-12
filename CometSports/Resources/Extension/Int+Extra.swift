//
//  Int+Extra.swift
//  Comet Sports
//
//  Created by iosDev on 06/03/2024.
//

import Foundation

extension Int {
    /// Here we are converting date in Unixtime (Number/Int) format to given output format date string
    /// Showing localized date
    func formatDate(outputFormat: dateFormat, today: Bool = false) -> String {
        let date = formatTimestampDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat.rawValue
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: selectedLang == .en ? "en" : "zh-Hans")
        let dateStr = dateFormatter.string(from: date)
        if today && Calendar.current.isDateInToday(date) {
            return "Today".localized
        } else {
            return dateStr
        }
    }
    /// Here we are converting date in Unixtime (Number/Int) format to date
    func formatTimestampDate() -> Date {
        let timestamp: TimeInterval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: timestamp)
        return date
    }
    
    static func parse(from string: String) -> Int? {
        Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
    
    func getMatchStatus() -> String {
        switch self {
        case 1:
            return "Not started".localized
        case 2:
            return "First half".localized
        case 3:
            return "Half-time".localized
        case 4:
            return "Second half".localized
        case 5:
            return "Overtime".localized
        case 6:
            return "Overtime(deprecated)".localized
        case 7:
            return "Penalty Shoot-out".localized
        case 8:
            return "End".localized
        case 9:
            return "Delay".localized
        case 10:
            return "Interrupt".localized
        case 11:
            return "Cut in half".localized
        case 12:
            return "Canceled".localized
        case 13:
            return "To be determined".localized
        default:
            return ""
        }
    }
}
