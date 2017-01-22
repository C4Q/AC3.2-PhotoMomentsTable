//
//  ViewController.swift
//  PhotoMomentsTable
//
//  Created by Annie Tung on 1/20/17.
//  Copyright © 2017 Annie Tung. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTableView: UITableView!
    let manager = PHImageManager.default()
    var topTierFetchResult = PHFetchResult<PHCollection>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("\n---Moments List---\n")
        let options = PHFetchOptions()

        let momentsLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: nil)
        
        for i in 0..<momentsLists.count {
            print("Title: ", momentsLists[i].localizedTitle ?? "no title")
            let moments = momentsLists[i]
            let collectionList = PHCollectionList.fetchCollections(in: moments, options:options)
            
            // for use in a table
            self.topTierFetchResult = collectionList
            
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
    
    // MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        guard topTierFetchResult.count > 0 else { return 1 }
        return topTierFetchResult.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = topTierFetchResult[section] as! PHAssetCollection
        let assets = PHAsset.fetchAssets(in: section, options: nil)
        return assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath)
        
        let collection = topTierFetchResult[indexPath.section] as! PHAssetCollection
        let assets = PHAsset.fetchAssets(in: collection, options: nil)
        let asset = assets[indexPath.row]
        if let collectionDate = asset.creationDate {
            cell.textLabel?.text = DateFormatter.localizedString(from: collectionDate, dateStyle: .medium, timeStyle: .medium)
        } else {
            print("No Date Available")
        }
        manager.requestImage(for: asset,
                             targetSize: CGSize(width: 100.0, height: 100.0),
                             contentMode: .aspectFill,
                             options: nil) { (result, _) in
                                DispatchQueue.main.async {
                                    cell.imageView?.image = result
                                    cell.setNeedsLayout()
                                    print(asset)
                                }
        }
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "assetIdentifier" {
            if let destinationVC = segue.destination as? DetailViewController,
                let indexPath = imageTableView.indexPath(for: sender as! UITableViewCell) {
                
                let collection = topTierFetchResult[indexPath.section] as! PHAssetCollection
                let assets = PHAsset.fetchAssets(in: collection, options: nil)
                let asset = assets[indexPath.row]
                
                destinationVC.asset = asset
            }
        }
    }
}

