//
//  SportsTabBar.swift
//  GenieSports
//
//  Created by Qasr01 on 02/05/2023.
//

import UIKit

class SportsTabBar: UITabBarController, UINavigationControllerDelegate, UITabBarControllerDelegate {
    
    @IBOutlet var TabView: UIView!
    @IBOutlet weak var tab1Btn: UIButton!
    @IBOutlet weak var tab2Btn: UIButton!
    @IBOutlet weak var tab3Btn: UIButton!
    @IBOutlet weak var tab4Btn: UIButton!
    
    var controllerArr : Array = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewDidLayoutSubviews() {
        var hght : CGFloat = 60
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 1920 {
                hght = 60
            }
            else if UIScreen.main.nativeBounds.height > 1700 {
                hght = 83
            } else {
                hght = 60
            }
        } else if UIDevice().userInterfaceIdiom == .pad {
            hght = 83
        }
        self.TabView.frame = CGRect(x: 0, y: self.view.frame.size.height-hght, width: self.view.frame.size.width, height: hght)
    }
    
    // MARK: - Methods
    func initialSettings() {
        
        self.navigationController?.delegate = self
        let controller1 = Storyboards.home.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let controller2 = Storyboards.home.instantiateViewController(withIdentifier: "MatchesVC") as! MatchesVC
        let controller3 = Storyboards.store.instantiateViewController(withIdentifier: "PriceCheckViewController") as! PriceCheckViewController
        let controller4 = Storyboards.setting.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        
        self.controllerArr.append(controller1)
        self.controllerArr.append(controller2)
        self.controllerArr.append(controller3)
        self.controllerArr.append(controller4)
        
        self.setViewControllers(self.controllerArr, animated: true)
        Bundle.main.loadNibNamed("TabbarView", owner: self, options:.none)
        var hght : CGFloat = 60
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 1920 {
                hght = 60
            }
            else if UIScreen.main.nativeBounds.height > 1700 {
                hght = 83
            } else {
                hght = 60
            }
        } else if UIDevice().userInterfaceIdiom == .pad {
            hght = 83
        }
        
        self.TabView.frame = CGRect(x: 0, y: self.view.frame.size.height-hght, width: self.view.frame.size.width, height: hght)
        self.view.addSubview(self.TabView)
        showInitialTab()
    }
    
    func showInitialTab() {
        self.unselectTab()
      //  UserModel.sharedInstance.selectedtab = 0
        self.selectedIndex = 0
        self.tab1Btn.isSelected = true
    }
    
    func unselectTab() {
        self.tab1Btn.isSelected = false
        self.tab2Btn.isSelected = false
        self.tab3Btn.isSelected = false
        self.tab4Btn.isSelected = false
    }
    
    // MARK: - Button Actions
    @IBAction func tabBtnTapped(_ sender: UIButton) {
        self.unselectTab()
        switch (sender.tag) {
        case 1:
            self.selectedIndex = 0
            self.tab1Btn.isSelected = true
            break
        case 2:
            self.selectedIndex = 1
            self.tab2Btn.isSelected = true
            break
        case 3:
            self.selectedIndex = 2
            self.tab3Btn.isSelected = true
            break
        case 4:
            self.selectedIndex = 3
            self.tab4Btn.isSelected = true
            break
        default:
            break
        }
        //UserModel.sharedInstance.selectedtab = self.selectedIndex
    }
}
