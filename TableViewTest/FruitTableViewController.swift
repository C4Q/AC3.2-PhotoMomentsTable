import UIKit
import Photos

class FruitsTableViewController: UITableViewController {
    let manager = PHImageManager.default()
    
    var imageAssets = [PHAsset]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var fetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumMyPhotoStream, options:nil)
        
        for i in 0..<fetchResult.count {
            let collection = fetchResult[i]
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            for j in 0..<assets.count {
                imageAssets.append(assets[j])
                if j > 10 {
                    break
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageAssets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        let asset = imageAssets[indexPath.row]
        
        cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        manager.requestImage(for: asset, targetSize: CGSize(width: 50.0, height: 50.0), contentMode: .aspectFill, options: nil) { (result, _) in
        
            cell.imageView?.image = result
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let dvc = DetailViewController()
//        let asset = imageAssets[indexPath.row]
//        
//        dvc.imageAsset = asset
//    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let dvc = segue.destination as? DetailViewController,
                let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                dvc.imageAsset = imageAssets[indexPath.row]
            }
        }
    
}
