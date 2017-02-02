//
//  ViewController.swift
//  photoBrowser
//
//  Created by Amber Spadafora on 1/21/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "photo"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var photoTable: UITableView!
    
    
    var momentsList: PHFetchResult<PHCollectionList>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
        photoTable.delegate = self
        photoTable.dataSource = self
        photoTable.rowHeight = 120
        photoTable.estimatedRowHeight = 120
        photoTable.sectionHeaderHeight = CGFloat(integerLiteral: 30)
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            DispatchQueue.main.async {
                let momentsLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: nil)
                self.momentsList = momentsLists
                self.photoTable.reloadData()
            }
        } else {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    DispatchQueue.main.async {
                        let momentsLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: nil)
                        self.momentsList = momentsLists
                        self.photoTable.reloadData()
                    }
                }
            })
        }
//        DispatchQueue.main.async {
//            let momentsLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: nil)
//            self.momentsList = momentsLists
//            self.photoTable.reloadData()
//        }
        
        
        
        
    }
    
    
    
    
    // MARK: TableView Delegates
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        return momentsList?[section].localizedTitle ?? "no title"
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title: UILabel = UILabel()
        
        title.text = momentsList?[section].localizedTitle ?? String(describing: momentsList![section].startDate!)
        title.textColor = UIColor(red: 77.0/255.0, green: 98.0/255.0, blue: 130.0/255.0, alpha: 1.0)
        title.backgroundColor = UIColor(red: 225.0/255.0, green: 243.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        title.font = UIFont.boldSystemFont(ofSize: 10)
        title.textAlignment = .center
        
        let constraint = NSLayoutConstraint.constraints(withVisualFormat: "H:[label]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: ["label": title])
        
        title.addConstraints(constraint)
        
        return title

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard momentsList != nil else { return 0 }
        return momentsList!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let collectionList = momentsList?[section]
        let assets = PHCollection.fetchCollections(in: collectionList!, options: nil)
        
        return assets.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PhotoTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PhotoTableViewCell
        
        
        cell.collectionList = momentsList?[indexPath.section]
        let assets = PHCollection.fetchCollections(in: cell.collectionList!, options: nil)
        let manager = PHImageManager.default()
        
        if cell.tag != 0 {
            manager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        
        if let collection = assets[indexPath.row] as? PHAssetCollection {
            
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            print(assets.count)
            let cellTag = Int(manager.requestImage(for: assets[indexPath.row],
                                 targetSize: CGSize(width: 110.0, height: 110.0),
                                 contentMode: .aspectFill,
                                 options: nil) { (result, _) in
                                    cell.imageForCell.image = result
                                    cell.setNeedsLayout()
            })
            cell.tag = cellTag
        }
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPic" {
            if let destinationVC = segue.destination as? EnlargedPhotoViewController,
                let indexPath = photoTable.indexPath(for: sender as! PhotoTableViewCell) {
                
                let collectionsFetch = PHCollection.fetchCollections(in: (momentsList?[indexPath.section])!, options: nil)
                let collection = collectionsFetch[indexPath.row] as! PHAssetCollection
                let assets = PHAsset.fetchAssets(in: collection, options: nil)
                let asset = assets[indexPath.row]
                destinationVC.assetForCell = asset
                
            }
            
        }
    }
    
    
    
    
}

