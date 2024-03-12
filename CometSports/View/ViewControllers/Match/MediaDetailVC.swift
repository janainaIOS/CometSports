//
//  MediaDetailVC.swift
//  Comet Sports
//
//  Created by iosDev on 19/07/2023.
//

import UIKit

class MediaDetailVC: UIViewController {
    
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var model = Medias()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Refresh for localization
        initialSettings()
    }
    
    func initialSettings() {
        imageIV.setImage(imageStr: model.preview)
        titleLBL.text = model.title
        contentTextView.text = model.subtitle
        dateLBL.text = model.date.formatDate(inputFormat: dateFormat.yyyyMMdd, outputFormat: dateFormat.ddMMMMyyyy).uppercased()
    }
    
    // MARK: - Button Actions
    @IBAction func playBTNTapped(_ sender: UIButton) {
        if let url = URL(string: model.video) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
