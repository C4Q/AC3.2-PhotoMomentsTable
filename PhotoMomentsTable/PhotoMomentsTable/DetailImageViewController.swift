//
//  DetailImageViewController.swift
//  PhotoMomentsTable
//
//  Created by Ana Ma on 1/22/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Photos

class DetailImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let manager = PHImageManager.default()
    var selectedAsset: PHAsset!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.requestImage(for: selectedAsset,
                             targetSize: CGSize(width: self.imageView.frame.width, height: self.imageView.frame.height),
                             contentMode: .aspectFill,
                             options: nil) { (result, _) in
                                self.imageView.image = result
        }
    }
}
