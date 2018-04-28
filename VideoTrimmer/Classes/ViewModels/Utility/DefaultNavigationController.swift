
import UIKit

class DefaultNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        guard let bar: UINavigationBar = rootViewController.navigationController?.navigationBar else {
            return
        }
        let fontSize: CGFloat = 17.0
        bar.isTranslucent = false
        bar.barTintColor = UIColor.white
        bar.tintColor = UIColor.ultraDarkGray
        bar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize, weight: .medium),
        ]
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
