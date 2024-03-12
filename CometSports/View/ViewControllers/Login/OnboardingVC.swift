//
//  OnboardingVC.swift
//  Comet Sports
//
//  Created by iosDev on 10/02/2024.
//

import UIKit

class OnboardingVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nextButton.setTitle("Next".localized, for: .normal)
        skipButton.setTitle("Skip".localized, for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    
    func configure() {
        guard UserDefaults.standard.onbordingLoaded != nil else {
            // show onboarding screen
            pageControl.numberOfPages = 3
            pageControl.currentPage = 0
            UserDefaults.standard.onbordingLoaded = true
            updateView()
            return
        }
        
        // onboarding screen already loaded
        let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "SportsTabBar") as! SportsTabBar
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func updateView() {
        switch pageControl.currentPage {
        case 1:
            coverImageView.image = UIImage(named: "onboarding_2")
            titleLabel.text = "Hot Matches".localized
            subTitleLabel.text = "All of your favorite matches in one place".localized
        case 2:
            coverImageView.image =  UIImage(named: "onboarding_2")
            titleLabel.text = "Price Checker".localized
            subTitleLabel.text = "Using our AI algorithm find the latest prices for all of your favorite sports products".localized
        default:
            coverImageView.image =  UIImage(named: "onboarding_1")
            titleLabel.text = "Latest Predictions".localized
            subTitleLabel.text = "Read the latest predictions and analyses from our experts".localized
        }
    }
    
    // MARK: - Button Actions
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if pageControl.currentPage > 1 {
            let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "SportsTabBar") as! SportsTabBar
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            pageControl.currentPage = pageControl.currentPage + 1
            updateView()
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "SportsTabBar") as! SportsTabBar
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

