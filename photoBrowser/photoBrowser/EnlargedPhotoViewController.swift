//
//  EnlargedPhotoViewController.swift
//  photoBrowser
//
//  Created by Amber Spadafora on 1/22/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Photos

class EnlargedPhotoViewController: UIViewController {
    
    var assetForCell: PHAsset?
    @IBOutlet weak var largePhoto: UIImageView!
    
    let manager = PHImageManager.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        manager.requestImage(for: assetForCell!,
                             targetSize: CGSize(width: largePhoto.heightAnchor.hashValue, height: largePhoto.widthAnchor.hashValue),
                             contentMode: .aspectFill,
                             options: nil) { (result, _) in
                                self.largePhoto.image = result
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
