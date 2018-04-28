
import UIKit

class DefaultButton: UIButton {
    
    var touchDown: (() -> Void)?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(self.onTouchDown(_:)), for: .touchDown)
    }
    
    
    @objc func onTouchDown(_ sender: UIButton) {
        self.touchDown?()
    }
    
}
