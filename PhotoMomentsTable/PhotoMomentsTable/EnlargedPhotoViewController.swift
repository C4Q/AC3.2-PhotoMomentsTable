//
//  EnlargedPhotoViewController.swift
//  PhotoMomentsTable
//
//  Created by Madushani Lekam Wasam Liyanage on 1/22/17.
//  Copyright © 2017 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import UIKit
import Photos

class EnlargedPhotoViewController: UIViewController {
    
    @IBOutlet weak var enlargedImageView: UIImageView!
    
    var selectedAsset: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let asset = selectedAsset {
            let manager = PHImageManager.default()
            manager.requestImage(for: asset,
                                 targetSize: CGSize(width: 500.0, height: 500.0),
                                 contentMode: .aspectFill,
                                 options: nil) { (result, _) in
                                    
                                    self.enlargedImageView.image = result
            }
            
            
        }
        
    }
    
    
}
