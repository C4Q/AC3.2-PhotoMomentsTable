//
//  FullImageViewController.swift
//  PhotosFramework
//
//  Created by Tong Lin on 1/22/17.
//  Copyright © 2017 Tong Lin. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {

    var myImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.image = myImage
        _ = [imageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
             imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].map{ $0.isActive = true }
    }

    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()

}
