//
//  FullImageViewController.swift
//  AC3.2-PhotoMomentsTable
//
//  Created by Tom Seymour on 1/22/17.
//  Copyright © 2017 C4Q-3.2. All rights reserved.
//

import UIKit
import Photos

class FullImageViewController: UIViewController {
    
    var thisAsset: PHAsset!
    
    
    @IBOutlet weak var fullImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = PHImageManager()
        
        let destinationSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        manager.requestImage(for: thisAsset, targetSize: destinationSize, contentMode: .aspectFit, options: nil, resultHandler: { (image: UIImage?, _) in
            if let unwrappedImage = image {
                self.fullImageView.image = unwrappedImage
            }
        })


    }

    
}
