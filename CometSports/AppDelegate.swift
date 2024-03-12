//
//  AppDelegate.swift
//  CometSports
//
//  Created by Qasr01 on 07/03/2024.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Displaying splash screen for longer than default seconds
        // Thread.sleep(forTimeInterval: 1.0)
        
        //setting device current language
        if let lastLanguage = UserDefaults.standard.appLanguage, lastLanguage != "" {
            
        } else {
            var deviceLanguage = DeviceLanguage.currentLanguage()
            deviceLanguage = deviceLanguage.contains("en") ? "en" : "zh"
            UserDefaults.standard.appLanguage = deviceLanguage
        }
        
        selectedLang = UserDefaults.standard.appLanguage == "zh" ? .zh : .en
        
        // Keyboard
        IQKeyboardManager.shared.placeholderColor = .clear
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localized
        IQKeyboardManager.shared.enable = true
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

