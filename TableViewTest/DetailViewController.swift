//
//  DetailViewController.swift
//  PhotoTest
//
//  Created by Eashir Arafat on 1/21/17.
//  Copyright © 2017 Evan. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: UIViewController {
    var imageAsset = PHAsset()
    let manager = PHImageManager.default()
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.requestImage(for: imageAsset, targetSize: CGSize(width: 300.0, height: 400.0), contentMode: .aspectFill, options: nil) { (result, _) in
            
            self.imageView?.image = result
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
