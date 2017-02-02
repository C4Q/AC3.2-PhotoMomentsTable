//
//  ViewController.swift
//  PhImageHomeWork
//
//  Created by Thinley Dorjee on 1/23/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    var bigImage: [PHAsset] = []
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = PHImageManager.default()
        manager.requestImage(for: bigImage[0],
                             targetSize: CGSize(width: 100.0, height: 100.0),
                             contentMode: .aspectFill,
                             options: nil) { (result, _) in
                                
                                self.imageView?.image = result
                                
                                //cell.setNeedsLayout()
        }
        
        

    }


}

