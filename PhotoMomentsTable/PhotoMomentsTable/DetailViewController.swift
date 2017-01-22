//
//  DetailViewController.swift
//  PhotoMomentsTable
//
//  Created by Annie Tung on 1/22/17.
//  Copyright © 2017 Annie Tung. All rights reserved.
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
                             targetSize: CGSize(width: 100.0, height: 100.0),
                             contentMode: .aspectFill,
                             options: nil) { (result, _) in
                                DispatchQueue.main.async {
                                    self.imageView?.image = result
                                }
        }
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
