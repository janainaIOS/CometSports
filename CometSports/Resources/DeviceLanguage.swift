//
//  DeviceLanguage.swift
//  Comet Sports
//
//  Created by iosDev on 24/07/2023.
//

import Foundation

struct DeviceLanguage {
    static func currentLanguage() -> String {
        let currentLanguage = (UserDefaults.standard.stringArray(forKey: "AppleLanguages") ?? [""]) //zh-Hans //en-US
        return "\(currentLanguage[0])"
    }
}
