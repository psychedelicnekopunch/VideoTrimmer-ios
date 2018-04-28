
import UIKit

extension UIColor {
    
    class var ultraDarkGray: UIColor {
        get {
            return self.rgbColor(rgbValue: 0x555555, alpha: 1.0)
        }
    }
    
    class var darkGray: UIColor {
        get {
            return self.rgbColor(rgbValue: 0x888888, alpha: 1.0)
        }
    }
    
    class var gray: UIColor {
        get {
            return self.rgbColor(rgbValue: 0xd5d5d5, alpha: 1.0)
        }
    }
    
    class var lightGray: UIColor {
        get {
            return self.rgbColor(rgbValue: 0xf2f2f2, alpha: 1.0)
        }
    }
    
    class var ultraLightGray: UIColor {
        get {
            return self.rgbColor(rgbValue: 0xf9f9f9, alpha: 1.0)
        }
    }
    
    class var red: UIColor {
        get {
            return self.rgbColor(rgbValue: 0xff7799, alpha: 1.0)
        }
    }
    
    
    class var green: UIColor {
        get {
            return self.rgbColor(rgbValue: 0xbee6d7, alpha: 1.0)
        }
    }
    
    
    class var yellow: UIColor {
        get {
            return self.rgbColor(rgbValue: 0xedff96, alpha: 1.0)
        }
    }
    
    
    class var lightYellow: UIColor {
        get {
            return self.rgbColor(rgbValue: 0xfcffda, alpha: 1.0)
        }
    }
    
    
    class var blue: UIColor {
        get {
            return self.rgbColor(rgbValue: 0xa2e4ff, alpha: 1.0)
        }
    }
    
    
    class var purple: UIColor {
        get {
            return self.rgbColor(rgbValue: 0xbbb8e1, alpha: 1.0)
        }
    }
    
    
    class func rgb(rgbValue: UInt, alpha: Float) -> UIColor {
        return UIColor.rgbColor(rgbValue: rgbValue, alpha: alpha)
    }
    
    
    class private func rgbColor(rgbValue: UInt, alpha: Float) -> UIColor {
        return UIColor(
            red:   CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >>  8) / 255.0,
            blue:  CGFloat( rgbValue & 0x0000FF)        / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
}
