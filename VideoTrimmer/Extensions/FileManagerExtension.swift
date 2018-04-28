
import UIKit

extension FileManager {
    
    static var sharedInstance: FileManager = FileManager()
    
    
    func remove(atPath: String) {
        if self.fileExists(atPath: atPath) {
            do {
                try self.removeItem(atPath: atPath)
            } catch _ {
            }
        }
    }
    
    
    class var videoUploadPath: String {
        get {
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let path : String = "\(documentsDirectory)/uploadVideo.mp4"
            return path
        }
    }
    
    
    class var videoUploadURL: URL {
        get {
            let paths = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
            var path = paths[0]
            path.appendPathComponent("uploadVideo.mp4")
            return path
        }
    }
    
    
    class var videoExportPath: String {
        get {
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let path : String = "\(documentsDirectory)/exportVideo.mp4"
            return path
        }
    }
    
    
    class var videoExportURL: URL {
        get {
            let paths = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
            var path = paths[0]
            path.appendPathComponent("exportVideo.mp4")
            return path
        }
    }
    
    
    class var tempVideoUploadPath: String {
        get {
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory = paths[0] as String
            //            let path : String = "\(documentsDirectory)/uploadTempVideo.mp4"
            let path : String = "\(documentsDirectory)/uploadTempVideo.MOV"
            return path
        }
    }
    
    
    class var tempVideoUploadURL: URL {
        get {
            let paths = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
            var path = paths[0]
            //            path.appendPathComponent("uploadTempVideo.mp4")
            path.appendPathComponent("uploadTempVideo.MOV")
            return path
        }
    }
    
    
    class var thumbnailUploadPath: String {
        get {
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let path : String = "\(documentsDirectory)/uploadThumbnail.png"
            return path
        }
    }
    
    
    class var thumbnailUploadURL: URL {
        get {
            let paths = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
            var path = paths[0]
            path.appendPathComponent("uploadThumbnail.png")
            return path
        }
    }
    
    
    class var profileUploadPath: String {
        get {
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let path : String = "\(documentsDirectory)/uploadProfile.png"
            return path
        }
    }
    
    
    class var profileUploadURL: URL {
        get {
            let paths = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
            var path = paths[0]
            path.appendPathComponent("uploadProfile.png")
            return path
        }
    }
    
    
    func fileSize(atPath: String) -> (error: Bool, size: UInt64) {
        do {
            let attr: NSDictionary = try self.attributesOfItem(atPath: atPath) as NSDictionary
            return (false, attr.fileSize())
        } catch _ {
            print("failed FileManager.default.attributesOfItem()")
            return (true, 0)
        }
    }
    
    
    // iClould にバックアップさせない
    class func forbidBackupToiCloud() {
        do {
            let paths: [String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentDirectory: String = paths[0] as String
            var docURL: URL = URL(fileURLWithPath: documentDirectory)
            var resources: URLResourceValues = URLResourceValues()
            resources.isExcludedFromBackup = true
            try docURL.setResourceValues(resources)
        } catch {
            print("failed setResourceValues()")
        }
    }
    
}
