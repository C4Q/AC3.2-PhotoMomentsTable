//
//  ViewController.swift
//  PhotoFrameworkDemo
//
//  Created by Victor Zhong on 1/20/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import Photos

class ViewController: UITableViewController {
    
    let reuseIdentifier = "reuseCell"
    
    var collectionFetchResult = PHFetchResult<PHCollection>()
    var assets: [PHAsset] = []
    
    var setResults = [UIImage]()
    var setInfo = [[AnyHashable : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\n---Moments List---\n")
//        let options = PHFetchOptions()
//        let sort = NSSortDescriptor(key: "startDate", ascending: false)
//        options.sortDescriptors = [sort]
//        let cutoffDate = NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 10 * -1)
//        let predicate = NSPredicate(format: "startDate > %@", cutoffDate)
//        options.predicate = predicate
        let momentsLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: nil)
        for i in 0..<momentsLists.count {
            print("Title: ", momentsLists[i].localizedTitle ?? "no title")
            let moments = momentsLists[i]
            let collectionList = PHCollectionList.fetchCollections(in: moments, options: nil)
            
            // for use in a table
            self.collectionFetchResult = collectionList
            
            for j in 0..<collectionList.count {
                if let collection = collectionList[j] as? PHAssetCollection {
                    printAssetsInList(collection: collection)
                }
            }
        }
    }
    
    //        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumMyPhotoStream, options:nil)
    //
    //        for i in 0..<fetchResult.count where fetchResult[i].localizedTitle == "Camera Roll"{
    //            print(fetchResult[i])
    //            let collection = fetchResult[i]
    //            print(collection.localizedTitle ?? "")
    //
    //            let assets = PHAsset.fetchAssets(in: collection, options: nil)
    //            print("\n---\(assets.count)---\n")
    //            for j in 0..<assets.count {
    //                print(assets[j])
    //                if j > 10 {
    //                    break
    //                }
    //
    //                let manager = PHImageManager.default()
    //                manager.requestImage(for: assets[j],
    //                                     targetSize: CGSize(width: 200.0, height: 200.0),
    //                                     contentMode: .aspectFill,
    //                                     options: nil ) { (result, info) in
    //
    //                                        // self.imageView.image = result
    //                                        if let image = result {
    //                                            self.setResults.append(image)
    //                                        }
    //
    //                                        if let info = info {
    //                                            self.setInfo.append(info)
    //                                        }
    //                }
    //            }
    //        }
    
        func printAssetsInList(collection: PHAssetCollection) {
            let asset = PHAsset.fetchAssets(in: collection, options: nil)
            print("\n---\(asset.count)---\n")
            for j in 0..<asset.count {
                print(asset[j])
                assets.append(asset[j])
                if j > 10 {
                    break
                }
            }
        }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("There are \(assets.count) assets")
        return assets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let manager = PHImageManager.default()
        
        if cell.tag != 0 {
            manager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        let asset = assets[indexPath.row]
        
        if let creationDate = asset.creationDate {
            cell.textLabel?.text = DateFormatter.localizedString(from: creationDate,
                                                                 dateStyle: .medium ,
                                                                 timeStyle: .medium)
        } else {
            cell.textLabel?.text = nil
        }
        
        cell.tag = Int(manager.requestImage(for: asset,
                                            targetSize: CGSize(width: 100.0, height: 100.0),
                                            contentMode: .aspectFill,
                                            options: nil) { (result, _) in
                                                if let destinationCell = tableView.cellForRow(at: indexPath) {
                                                    destinationCell.imageView?.image = result
                                                }
        })
        
        return cell
        
        //        cell.imageView?.image = setResults[indexPath.row]
        //
        //        return cell
    }
}

//        print("\n---Regular Albums---\n")
//        fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options:nil)
//        for result in 0..<fetchResult.count {
//            print(fetchResult.object(at: result))
//        }
//
//        // different way of getting to the same data
//        print("\n---Top Level---\n")
//        let collectionList = PHCollectionList.fetchTopLevelUserCollections(with: nil)
//        for i in 0..<collectionList.count {
//            print(collectionList[i])
//            if let collection = collectionList[i] as? PHAssetCollection {
//                print("Identifier: \(collection.localIdentifier)")
//                print(collection.localizedTitle ?? "")
//
//                let assets = PHAsset.fetchAssets(in: collection, options: nil)
//                print("\n---\(assets.count)---\n")
//                for j in 0..<assets.count {
//                    print(assets[j])
//                    let manager = PHImageManager.default()
//                    manager.requestImage(for: assets[j],
//                                         targetSize: CGSize(width: 100.0, height: 100.0),
//                                         contentMode: .aspectFill,
//                                         options: nil) { (result, _) in
//                                            self.imageView.image = result
//                    }
//                    if j > 10 {
//                        break
//                    }
//                }
//            }
//        }

//        print("\n---Moments List---\n")
//        let options = PHFetchOptions()
//        let sort = NSSortDescriptor(key: "startDate", ascending: false)
//        options.sortDescriptors = [sort]
//        let cutoffDate = NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 10 * -1)
//        let predicate = NSPredicate(format: "startDate > %@", cutoffDate)
//        options.predicate = predicate
//        let momentsLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: nil)
//        for i in 0..<momentsLists.count {
//            print("Title: ", momentsLists[i].localizedTitle ?? "no title")
//            let moments = momentsLists[i]
//            let collectionList = PHCollectionList.fetchCollections(in: moments, options:options)
//
//            // for use in a table
//            //self.collectionFetchResult = collectionList
//
//            for j in 0..<collectionList.count {
//                print("Moment: \(collectionList[j].localizedTitle)")
//                if let collection = collectionList[j] as? PHAssetCollection {
//                    printAssetsInList(collection: collection)
//                }
//            }
//        }
//    }

//    func printAssetsInList(collection: PHAssetCollection) {
//        let assets = PHAsset.fetchAssets(in: collection, options: nil)
//        print("\n---\(assets.count)---\n")
//        for j in 0..<assets.count {
//            print(assets[j])
//            let manager = PHImageManager.default()
//            manager.requestImage(for: assets[j],
//                                 targetSize: CGSize(width: 100.0, height: 100.0),
//                                 contentMode: .aspectFill,
//                                 options: nil) { (result, _) in
//                                    self.imageView.image = result
//            }
//            if j > 10 {
//                break
//            }
//        }
//    }


