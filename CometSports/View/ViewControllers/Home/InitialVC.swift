//
//  InitialVC.swift
//  Comet Sports
//
//  Created by iosDev on 27/05/2023.
//

import UIKit

class InitialVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard UserDefaults.standard.onbordingLoaded != nil else {
            // onboarding screen already loaded
            let nextVC = Storyboards.login.instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
            self.navigationController?.pushViewController(nextVC, animated: true)
            return
        }
        
        // onboarding screen already loaded
        let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "SportsTabBar") as! SportsTabBar
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
}
