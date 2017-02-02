//
//  PhotoTableViewCell.swift
//  photoBrowser
//
//  Created by Amber Spadafora on 1/22/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Photos

class PhotoTableViewCell: UITableViewCell {

    var assetColl: PHAssetCollection?
    
    @IBOutlet weak var imageForCell: UIImageView!
    var collectionList: PHCollectionList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
