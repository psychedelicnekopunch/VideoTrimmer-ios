
import UIKit
import Photos

class ALCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var durationLabel: ALDurationLabel!
    
    
    var asset: PHAsset? {
        get {
            return self.originAsset
        }
    }
    
    private var originAsset: PHAsset?
    
    
    func setCell(asset: PHAsset, size: CGSize) {
        
        self.originAsset = asset
        
        asset.toImage(size: size, contentMode: .aspectFill) { (image: UIImage?) in
            self.imageView.image = image
        }
        
        switch asset.mediaType {
        case .video:
            durationLabel.text = asset.duration.toFormatedString()
        default:
            durationLabel.text = ""
            break
        }
        
    }
    
}
