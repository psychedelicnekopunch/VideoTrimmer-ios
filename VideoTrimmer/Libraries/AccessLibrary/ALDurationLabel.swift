
import UIKit

class ALDurationLabel: UILabel {
    
    let padding: UIEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
    
    override var text: String? {
        didSet {
            if let text: String = self.text {
                if text != "" {
                    self.backgroundColor = UIColor.rgb(rgbValue: 0x000000, alpha: 0.7)
                    self.textColor = UIColor.white
                    return
                }
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width + self.padding.left + self.padding.right, height: super.intrinsicContentSize.height + self.padding.top + self.padding.bottom)
        }
    }
    
    override func drawText(in rect: CGRect) {
        let newRect: CGRect = UIEdgeInsetsInsetRect(rect, self.padding)
        super.drawText(in: newRect)
    }
    
}
