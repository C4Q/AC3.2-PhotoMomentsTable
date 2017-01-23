//
//  DetailViewController.swift
//  PhotoFrameworkDemo
//
//  Created by Victor Zhong on 1/22/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var photo: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedPhoto = photo {
            let manager = PHImageManager.default()
            
            manager.requestImage(for: selectedPhoto,
                                 targetSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
                                 contentMode: .aspectFit,
                                 options: nil) { (image: UIImage?, _) in
                                    
                                    self.imageView.image = image
                                    
            }
        }
    }
}
