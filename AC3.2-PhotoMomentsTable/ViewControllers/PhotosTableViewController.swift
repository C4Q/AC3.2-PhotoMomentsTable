//
//  PhotosTableViewController.swift
//  AC3.2-PhotoMomentsTable
//
//  Created by Sabrina Ip on 1/22/17.
//  Copyright © 2017 Sabrina. All rights reserved.
//

import UIKit
import Photos

class PhotosTableViewController: UITableViewController {
    
    // MARK: - Properties
    var collectionFetchResult = PHFetchResult<PHCollection>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200.0
        
        let options = PHFetchOptions()
        let sort = NSSortDescriptor(key: "startDate", ascending: false)
        options.sortDescriptors = [sort]
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumMyPhotoStream, options: options)
        collectionFetchResult = fetchResult as! PHFetchResult<PHCollection>
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.collectionFetchResult.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.collectionFetchResult[section].localizedTitle ?? "Unknown location"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let collection = self.collectionFetchResult[section] as! PHAssetCollection
        let assets = PHAsset.fetchAssets(in: collection, options: nil)
        return assets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! IndividualPhotoTableViewCell
        let manager = PHImageManager.default()
        if cell.tag != 0 {
            manager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        let collection = self.collectionFetchResult[indexPath.section] as! PHAssetCollection
        let assets = PHAsset.fetchAssets(in: collection, options: nil)
        let asset = assets[indexPath.row]
        
        cell.nameLabel.text = asset.localIdentifier
        
        if let creationDate = asset.creationDate {
            cell.dateLabel.text = DateFormatter.localizedString(from: creationDate, dateStyle: .medium, timeStyle: .medium)
        } else {
            cell.dateLabel.text = "Unknown date"
        }
        
        cell.sizeLabel.text = "\(asset.pixelWidth) pixels × \(asset.pixelHeight) pixels"
        
        cell.tag = Int(manager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFill, options: nil) { (image, _) in
            if let image = image {
                cell.imageView?.image = image
                DispatchQueue.main.async {
                    cell.setNeedsLayout()
                }
            }
        })
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? FullPhotoViewController,
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let collection = self.collectionFetchResult[indexPath.section] as! PHAssetCollection
                let assets = PHAsset.fetchAssets(in: collection, options: nil)
                let asset = assets[indexPath.row]
                dvc.pictureAsset = asset
        }
    }
}
