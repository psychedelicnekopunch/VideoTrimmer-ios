
import Photos

extension PHAsset {
    
    func toImage(size: CGSize, contentMode: PHImageContentMode, callback: @escaping (_ image: UIImage?) -> Void) {
        let options: PHImageRequestOptions = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        let manager: PHImageManager = PHImageManager()
        manager.requestImage(for: self, targetSize: size, contentMode: contentMode, options: options) { (image: UIImage?, info: [AnyHashable: Any]?) in
            callback(image)
        }
    }
    
    func toImage(callback: @escaping (_ imageData: Data?) -> Void) {
        let options: PHImageRequestOptions = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        let manager: PHImageManager = PHImageManager()
        manager.requestImageData(for: self, options: options) { (imageData: Data?, dataUTI: String?, orientation: UIImageOrientation, info: [AnyHashable: Any]?) in
            callback(imageData)
        }
    }
    
    func toAVAsset(callback: @escaping (_ asset: AVAsset?) -> Void) {
        let options: PHVideoRequestOptions = PHVideoRequestOptions()
        let manager: PHImageManager = PHImageManager()
        manager.requestAVAsset(forVideo: self, options: options) { (asset: AVAsset?, audio: AVAudioMix?, info: [AnyHashable: Any]?) in
            callback(asset)
        }
    }
    
}
