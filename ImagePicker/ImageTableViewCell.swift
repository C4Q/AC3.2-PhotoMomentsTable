//
//  ImageTableViewCell.swift
//  ImagePicker
//
//  Created by Jason Gresh on 1/23/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var dateLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
