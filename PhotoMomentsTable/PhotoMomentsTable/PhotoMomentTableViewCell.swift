//
//  PhotoMomentTableViewCell.swift
//  PhotoMomentsTable
//
//  Created by Madushani Lekam Wasam Liyanage on 1/22/17.
//  Copyright © 2017 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import UIKit

class PhotoMomentTableViewCell: UITableViewCell {

    @IBOutlet weak var momentsImageView: UIImageView!
    
    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
