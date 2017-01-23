//
//  DetailViewController.swift
//  ImagePicker
//
//  Created by Jason Gresh on 1/23/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var asset: PHAsset!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let manager = PHImageManager.default()

        manager.requestImage(for: asset,
                             targetSize: self.imageView.bounds.size,
                             contentMode: .aspectFit, options: nil) { (result, _) in
                            self.imageView.image = result
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
