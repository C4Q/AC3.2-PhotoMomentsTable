//
//  IndividualPhotoTableViewCell.swift
//  AC3.2-PhotoMomentsTable
//
//  Created by Sabrina Ip on 1/22/17.
//  Copyright © 2017 Sabrina. All rights reserved.
//

import UIKit

class IndividualPhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
