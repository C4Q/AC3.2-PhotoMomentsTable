//
//  TableViewController.swift
//  PhImageHomeWork
//
//  Created by Thinley Dorjee on 1/23/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Photos

class TableViewController: UITableViewController {

    
    var collectionOfImage: [PHAsset] = []
    
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
            let collectionList = PHCollectionList.fetchCollections(in: moments, options: nil)
            
            for j in 0..<collectionList.count {
                if let collection = collectionList[j] as? PHAssetCollection {
                    
                    let assets = PHAsset.fetchAssets(in: collection, options: nil)
                    print("\n---\(assets.count)---\n")
                    for k in 0..<assets.count {
                        collectionOfImage.append(assets[k])
                        print(assets[k])
                        if k > 10 {
                            break
                        }
                    }
                    
                }
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return collectionOfImage.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let thisImage = collectionOfImage[indexPath.row]
        
        
        let manager = PHImageManager.default()
        manager.requestImage(for: thisImage,
                             targetSize: CGSize(width: 100.0, height: 100.0),
                             contentMode: .aspectFill,
                             options: nil) { (result, _) in
                                
                                cell.imageView?.image = result
                                
                                cell.setNeedsLayout()
        }

    
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowView"{
            if let destination = segue.destination as? ViewController,
                let cell  = sender as? UITableViewCell,
                let ip = tableView.indexPath(for: cell) {
                
                destination.bigImage = [collectionOfImage[ip.row]]
                
            }
        }
    }
    


}
