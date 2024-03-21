//
//  Notification.swift
//  Comet Sports
//
//  Created by iosDev on 11/08/2023.
//

import Foundation
import CloudKit

class CloudNotification {
    static let recordType = "Settings"
    var hasUpdate: Int64 = 0
    var openType: Int64 = 0
    var keyword: String = ""
    var url: String = ""
    var message: String = ""
    
    init?(record: CKRecord, database: CKDatabase) {
        self.hasUpdate = record["hasUpdate"] as? Int64 ?? 0
        self.openType = record["type"] as? Int64 ?? 0
        self.keyword = record["keyword"] as? String ?? ""
        self.url = record["url"] as? String ?? ""
        self.message = record["message"] as? String ?? ""
    }
}
