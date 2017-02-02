//
//  PhotoMomentsTableViewController.swift
//  PhotoMomentsTable
//
//  Created by Ana Ma on 1/22/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Photos

public enum PHAssetCollectionType : Int {
    case album
    case smartAlbum
    case moment
}

class PhotoMomentsTableViewController: UITableViewController {
    
    let manager = PHImageManager.default()
    let cellIdentifier = "photoImageCellIdentifier"
    var assets: [PHAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let options = PHFetchOptions()
        let sort = NSSortDescriptor(key: "startDate", ascending: false)
        options.sortDescriptors = [sort]
        let cutoffDate = NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 10 * -1)
        let predicate = NSPredicate(format: "startDate > %@", cutoffDate)
        options.predicate = predicate
        
        let momentsLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: nil)
        for i in 0..<momentsLists.count {
            print("Title: ", momentsLists[i].localizedTitle ?? "no title")
            let moments = momentsLists[i]
            
            let collectionList = PHCollectionList.fetchCollections(in: moments, options:nil)
            
            guard let validCollection = collectionList.firstObject else { return }
            let results = PHAsset.fetchAssets(in: validCollection as! PHAssetCollection, options: nil)
            results.enumerateObjects({ (object, _, _) in
                self.assets.append(object)
            })
            guard let validAsset = results.firstObject else { return }
            dump(validAsset)
            manager.requestImage(for: validAsset,
                                 targetSize: CGSize(width: 100.0, height: 100.0),
                                 contentMode: .aspectFit,
                                 options: nil) { (result, _) in
                                    //self.photoImageView.image = result
            }
            
            for j in 0..<collectionList.count {
                if let collection = collectionList[j] as? PHAssetCollection {
                    printAssetsInList(collection: collection)
                }
            }
        }
    }
    
    func printAssetsInList(collection: PHAssetCollection) {
        let assets = PHAsset.fetchAssets(in: collection, options: nil)
        print("\n---\(assets.count)---\n")
        for j in 0..<assets.count {
            print(assets[j])
            if j > 10 {
                break
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let manager = PHImageManager.default()
        
        if cell.tag != 0 {
            manager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        let asset = assets[indexPath.row]
        
        if let creationDate = asset.creationDate {
            cell.textLabel?.text = DateFormatter.localizedString(from: creationDate,
                                                                 dateStyle: .medium,
                                                                 timeStyle: .medium)
        } else {
            cell.textLabel?.text = nil
        }
        
        DispatchQueue.main.async {
            cell.tag = Int(manager.requestImage(for: asset,
                                                targetSize: CGSize(width: 100.0, height: 100.0),
                                                contentMode: .aspectFill,
                                                options: nil) { (result, _) in
                                                    if let destinationCell = tableView.cellForRow(at: indexPath) {
                                                        destinationCell.imageView?.image = result
                                                    }
            })
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailImageViewControllerSegue" {
            let detailImageViewController = segue.destination as! DetailImageViewController
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    let selectedAsset = assets[indexPath.row]
                    detailImageViewController.selectedAsset = selectedAsset
                }
            }
        }
    }
}
