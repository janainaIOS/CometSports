//
//  NotificationViewModel.swift
//  Comet Sports
//
//  Created by iosDev on 07/03/2024.
//

import Foundation
import CloudKit

class NotificationViewModel {
    // MARK: - iCloud Info
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase
    
    // MARK: - Properties
    
    var notification:CloudNotification?
    var notificationList:[CloudNotification] = []
    
    static var shared = NotificationViewModel()
    
    init() {
        container = CKContainer(identifier: "iCloud.com.sports.CometSportsLive")
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    func getNotifications(_ completion: @escaping (Error?) -> Void) {
        let predicate = NSPredicate(value: true)
        let sortdescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        let query = CKQuery(recordType: "Settings", predicate: predicate)
        query.sortDescriptors = [sortdescriptor]
        
        notifications(forQuery: query, completion)
    }
    
    private func notifications(forQuery query: CKQuery, _ completion: @escaping (Error?) -> Void) {
        
        publicDB.perform(query, inZoneWith: CKRecordZone.default().zoneID) { [weak self] results, error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            guard let results = results else { return }
            guard let obj = results.last else {return}
            self.notification = CloudNotification(record: obj, database: self.publicDB)
            UserDefaults.standard.showAlert = self.notification?.openType
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
}
