//
//  PickerTableViewController.swift
//  ImagePicker
//
//  Created by Jason Gresh on 1/19/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Photos

class PickerTableViewController: UITableViewController {
    //var assets: [PHAsset] = []
    var assetFetchResult: PHFetchResult<PHAsset>?
    var collectionFetchResult: PHFetchResult<PHCollection>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.tableView.rowHeight = 200
////        self.tableView.estimatedRowHeight = 100
////        self.tableView.rowHeight = UITableViewAutomaticDimension
//
//        // load the collections
//        //let options = PHFetchOptions()
//        //let sort = NSSortDescriptor(key: "startDate", ascending: false)
//        //options.sortDescriptors = [sort]
//        // .albumRegular = My Albums
//        // .any = My Albums + Shared
//       //let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options:options)
////        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options:options)
//        print("\n---Smart Albums---\n")
//        var fetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options:nil)
//        for result in 0..<fetchResult.count {
//            print(fetchResult.object(at: result))
//        }
//
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
//                //printAssetsInList(collection: collection)
////                let assets = PHAsset.fetchAssets(in: collection, options: nil)
////                print("\n---\(assets.count)---\n")
////                for j in 0..<assets.count {
////                    print(assets[j])
////                    if j > 10 {
////                        break
////                    }
////                }
//            }
//        }
        
        
        print("\n---Moments List---\n")
        let options = PHFetchOptions()
        //let sort = NSSortDescriptor(key: "startDate", ascending: false)
        //options.sortDescriptors = [sort]
        let cutoffDate = NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 10 * -1)
        let predicate = NSPredicate(format: "startDate > %@", cutoffDate)
        options.predicate = predicate
        
        // highest level moment "clusters": groups of moments
        let clusters = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: nil)
        for i in 0..<clusters.count {
            print("Title: ", clusters[i].localizedTitle ?? "no title")
            let moments = clusters[i]
            let collectionList = PHCollectionList.fetchCollections(in: moments, options:options)
            
            // save for table
            self.collectionFetchResult = collectionList
            
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getAssetsForSection(section: Int) -> PHFetchResult<PHAsset>? {
        let options = PHFetchOptions()
        let predicate =  NSPredicate(format: "mediaType = %i", PHAssetMediaType.image.rawValue)
        options.predicate = predicate
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sort]
        if let result = self.collectionFetchResult,
            let collection = result[section] as? PHAssetCollection {
            return PHAsset.fetchAssets(in: collection, options: options)
        }
        return nil
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.collectionFetchResult?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let assets = getAssetsForSection(section: section) {
            return assets.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ImageTableViewCell
        
        guard let assets = getAssetsForSection(section: indexPath.section) else {
            return cell
        }

        let manager = PHImageManager.default()
        
        if cell.tag != 0 {
            manager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        let asset = assets[indexPath.row]
        
        if let creationDate = asset.creationDate {
            cell.dateLable.text = DateFormatter.localizedString(from: creationDate, dateStyle: .medium, timeStyle: .medium)
        }
        else {
            cell.dateLable.text = nil
        }
        
        cell.tag = Int(manager.requestImage(for: asset,
                                            targetSize: CGSize(width: 200.0, height: 200.0),
                                            contentMode: .aspectFit, options: nil) { (result, _) in
                                                if let destinationCell = tableView.cellForRow(at: indexPath) as? ImageTableViewCell {
                                                    destinationCell.theImageView.image = result
                                                    destinationCell.setNeedsLayout()
                                                }
        });
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let result = self.collectionFetchResult,
            let collection = result[section] as? PHAssetCollection {
            return collection.localizedTitle
        }
        return ""
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController,
            let cell = sender as? ImageTableViewCell,
            let indexPath = self.tableView.indexPath(for: cell) {
            if let assets = getAssetsForSection(section: indexPath.section) {
                vc.asset = assets[indexPath.row]
            }
        }
    }
}
