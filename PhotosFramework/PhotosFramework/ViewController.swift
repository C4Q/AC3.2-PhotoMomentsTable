//
//  ViewController.swift
//  PhotosFramework
//
//  Created by Tong Lin on 1/22/17.
//  Copyright © 2017 Tong Lin. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    var assets: [PHAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        print("\n---Moments List---\n")
        let options = PHFetchOptions()
        let sort = NSSortDescriptor(key: "startDate", ascending: false)
        options.sortDescriptors = [sort]
        let momentsLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: nil)
        self.assets = []
        for i in 0..<momentsLists.count {
            print("Title: ", momentsLists[i].localizedTitle ?? "no title")
            let moments = momentsLists[i]
            let collectionList = PHCollectionList.fetchCollections(in: moments, options:options)
            
            // for use in a table
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
            self.assets.append(assets[j])
            dump(assets[j])
            
        }
    }
    
    //MARK: - table view delegation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let manager = PHImageManager.default()
        
        if cell.tag != 0 {
            manager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        let asset = assets[indexPath.row]
        
        if let creationDate = asset.creationDate {
            cell.textLabel?.text = DateFormatter.localizedString(from: creationDate, dateStyle: .medium, timeStyle: .medium
            )
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
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FullImageViewController()
        let manager = PHImageManager.default()
        manager.requestImage(for: assets[indexPath.row],
                             targetSize: CGSize(width: 3000.0, height: 2000.0),
                             contentMode: .aspectFit,
                             options: nil) { (result, _) in
                                vc.myImage = result
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

