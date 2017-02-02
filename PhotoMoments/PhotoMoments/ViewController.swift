//
//  ViewController.swift
//  PhotoMoments
//
//  Created by C4Q on 1/22/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Photos

class FullImageViewController: UIViewController {
    
    @IBOutlet weak var fullImageView: UIImageView!
    var pictureAsset: PHAsset!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = PHImageManager.default()
        
        manager.requestImage(for: pictureAsset, targetSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), contentMode: .aspectFill, options: nil) { (image: UIImage?, _) in
            if let unwrappedImage = image {
                self.fullImageView?.image = unwrappedImage
            }
        }
    }
}

