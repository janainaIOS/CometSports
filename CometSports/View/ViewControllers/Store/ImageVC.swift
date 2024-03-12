//
//  ImageVC.swift
//  Comet Sports
//
//  Created by iosDev on 28/07/2023.
//

import UIKit
import Kingfisher

class ImageVC: UIViewController {
    
    @IBOutlet weak var imageSV: ImageScrollView!
    
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIImageView().kf.setImage(with: URL(string: URLs.productImage + imageName)) { result in
            switch result {
            case .success(let value):
                self.imageSV.display(image: value.image)
            case .failure(let error):
                print("Error Image: \(error)")
            }
        }
    }
}
