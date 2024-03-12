//
//  Bundle-Extra.swift
//  Comet Sports
//
//  Created by iosDev on 31/07/2023.
//

import Foundation

public extension Bundle {
     static var appName: String {
         let displyName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
         let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
         return displyName == "" ? bundleName : displyName
    }

     static var appVersion: String {
        guard let str = main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return "" }
        return str
    }

     static var appBuildNum: String {
        guard let str = main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else { return "" }
        return str
    }

     static var identifier: String {
        guard let str = Bundle.main.bundleIdentifier else { return "" }
        return str
    }
}


