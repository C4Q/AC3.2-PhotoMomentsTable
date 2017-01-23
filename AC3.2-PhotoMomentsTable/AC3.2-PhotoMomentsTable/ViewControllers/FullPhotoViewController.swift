//
//  FullPhotoViewController.swift
//  AC3.2-PhotoMomentsTable
//
//  Created by Sabrina Ip on 1/22/17.
//  Copyright © 2017 Sabrina. All rights reserved.
//

import UIKit
import Photos

class FullPhotoViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    var pictureAsset: PHAsset!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let manager = PHImageManager.default()
        manager.requestImage(for: pictureAsset, targetSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), contentMode: .aspectFit, options: nil) { (image, _) in
            if let image = image {
                self.photo.image = image
            }
        }        
    }
    
}
