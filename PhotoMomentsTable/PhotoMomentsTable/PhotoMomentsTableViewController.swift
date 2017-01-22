//
//  PhotoMomentsTableViewController.swift
//  PhotoMomentsTable
//
//  Created by Madushani Lekam Wasam Liyanage on 1/22/17.
//  Copyright © 2017 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import UIKit
import Photos

class PhotoMomentsTableViewController: UITableViewController {
    
    let reuseIdentifier = "momentsCellIdentifier"
    var momentsCollection: [PHAssetCollection] = []
    var assetsArr: [PHAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMoments()
        
        self.tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return assetsArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PhotoMomentTableViewCell
        
        let asset = assetsArr[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset,
                             targetSize: CGSize(width: 300.0, height: 300.0),
                             contentMode: .aspectFill,
                             options: nil) { (result, _) in
                                
                                cell.momentsImageView.image = result
                                
        }
        
        if let creationDate = asset.creationDate {
            cell.dateCreatedLabel?.text = DateFormatter.localizedString(from: creationDate,
                                                                        dateStyle: .medium,
                                                                        timeStyle: .medium
            )
        } else {
            cell.dateCreatedLabel?.text = "Created Date Not Available"
        }
        
        return cell
    }
    
    func getMoments() {
        
        //print("\n---Moments List---\n")
        let options = PHFetchOptions()
        let sort = NSSortDescriptor(key: "startDate", ascending: false)
        options.sortDescriptors = [sort]
        let cutoffDate = NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 10 * -1)
        let predicate = NSPredicate(format: "startDate > %@", cutoffDate)
        options.predicate = predicate
        let momentsLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: nil)
        
        
        for i in 0..<momentsLists.count {
            // print("Title: ", momentsLists[i].localizedTitle ?? "no title")
            let moments = momentsLists[i]
            let collectionList = PHCollectionList.fetchCollections(in: moments, options:options)
            
            // for use in a table
            //self.collectionFetchResult = collectionList
            
            for j in 0..<collectionList.count {
                if let collection = collectionList[j] as? PHAssetCollection {
                    
                    assetsArr =  getAssets(collection: collection)
                }
            }
        }
    }
    
    func getAssets(collection: PHAssetCollection) -> [PHAsset] {
        
        let assets = PHAsset.fetchAssets(in: collection, options: nil)
        var returnAssets = [PHAsset]()
        //print("\n---\(assets.count)---\n")
        for j in 0..<assets.count {
            //print(assets[j])
            returnAssets.append(assets[j])
            if j > 10 {
                break
            }
        }
        
        return returnAssets
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "enlargedPhotoSegueIdentifier" {
            if let epvc = segue.destination as? EnlargedPhotoViewController ,
                let cell = sender as? PhotoMomentTableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                epvc.selectedAsset = assetsArr[indexPath.row]
            }
        }
        
    }
    
}
