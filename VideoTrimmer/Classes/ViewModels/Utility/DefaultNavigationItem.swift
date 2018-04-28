
import UIKit

class DefaultNavigationItem {
    
    var item: UINavigationItem
    
    var onLeftItemCallback: (() -> Void)?
    
    var onRightItemCallback: (() -> Void)?
    
    
    enum ItemType {
        case back
        case close
    }
    
    
    init(item: UINavigationItem) {
        self.item = item
    }
    
    
    func addLeftItem(type: ItemType, didSelect: @escaping () -> Void) {
        
        let named: String
        
        switch type {
        case .back:
            named = "icon_angle_left_s"
        case .close:
            named = "icon_close_s"
        }
        
        self.item.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: named), style: .plain, target: self, action: #selector(self.onLeftItem(_:)))
        self.onLeftItemCallback = {
            didSelect()
        }
    }
    
    
    func addRightItem(named: String, didSelect: @escaping () -> Void) {
        self.item.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: named), style: .plain, target: self, action: #selector(self.onRightItem(_:)))
        self.onRightItemCallback = {
            didSelect()
        }
    }
    
    
    @objc private func onLeftItem(_ sender: UIButton) {
        self.onLeftItemCallback?()
    }
    
    
    @objc private func onRightItem(_ sender: UIButton) {
        self.onRightItemCallback?()
    }
    
}
