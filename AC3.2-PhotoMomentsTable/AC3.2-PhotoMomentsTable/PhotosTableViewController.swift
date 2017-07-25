//
//  PhotosTableViewController.swift
//  AC3.2-PhotoMomentsTable
//
//  Created by Tom Seymour on 1/22/17.
//  Copyright © 2017 C4Q-3.2. All rights reserved.
//

import UIKit
import Photos

class PhotosTableViewController: UITableViewController {

    let fullImageSegue = "fullImageSegue"
    
    var collectionFetchResult: PHFetchResult<PHCollection>!
    var assetsFetchResult: PHFetchResult<PHAsset>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let momentsLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: nil)
        print("Total number of lists of moments: \(momentsLists.count)")
        for i in 0..<momentsLists.count {
            print("Title: ", momentsLists[i].localizedTitle ?? "no title")
            let moments = momentsLists[i]
            let collectionList = PHCollectionList.fetchCollections(in: moments, options: nil)
            
            // for use in a table
            self.collectionFetchResult = collectionList
            print("collectionFetchResult count: \(self.collectionFetchResult.count)")
            
            for j in 0..<collectionFetchResult.count {
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
        return collectionFetchResult.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let collection = self.collectionFetchResult[section] as! PHAssetCollection
        return collection.localizedTitle ?? "No Tile For Collection"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let collection = self.collectionFetchResult[section] as! PHAssetCollection
        let assets = PHAsset.fetchAssets(in: collection, options: nil)
        return assets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCellIdentifier", for: indexPath)
        
        let imageManager = PHImageManager()
        let thisCollection = self.collectionFetchResult[indexPath.section] as! PHAssetCollection
        let assets = PHAsset.fetchAssets(in: thisCollection, options: nil)
        let asset = assets[indexPath.row]

        if let creationDate = asset.creationDate {
            cell.textLabel?.text = DateFormatter.localizedString(from: creationDate, dateStyle: .medium, timeStyle: .medium)
        } else {
            cell.textLabel?.text = "No Date Avialible"
        }
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFill, options: nil) { (image: UIImage?, _) in
                                    if let destinationCell = tableView.cellForRow(at: indexPath),
                                        let unwrappedImage = image {
                                        print("The loaded image: \(unwrappedImage)")
                                        destinationCell.imageView?.image = unwrappedImage
                                        
                                        DispatchQueue.main.async {
                                            cell.setNeedsLayout()
                                        }
                                    }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == fullImageSegue {
            if let dvc = segue.destination as? FullImageViewController, let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let collection = collectionFetchResult[indexPath.section] as! PHAssetCollection
                let assets = PHAsset.fetchAssets(in: collection, options: nil)
                let thisAsset = assets[indexPath.row]
                dvc.thisAsset = thisAsset
            }
        }
    }
}
