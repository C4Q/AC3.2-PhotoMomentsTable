//
//  FullScreenImageViewController.swift
//  AC3.2-PhotoMomentsTable
//
//  Created by Harichandan Singh on 1/21/17.
//  Copyright © 2017 Harichandan Singh. All rights reserved.
//

import UIKit
import Photos

class FullScreenImageViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var fullScreenImageView: UIImageView!
    var pictureAsset: PHAsset!
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = PHImageManager.default()
        
        manager.requestImage(for: pictureAsset, targetSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
                             contentMode: .aspectFill,
                             options: nil) { (image: UIImage?, _) in
                                
                                if let unwrappedImage = image {
                                    self.fullScreenImageView?.image = unwrappedImage
                                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
