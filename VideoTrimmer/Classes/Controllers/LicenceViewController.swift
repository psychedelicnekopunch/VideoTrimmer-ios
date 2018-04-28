
import UIKit

class LicenceViewController: UIViewController {
    
    @IBOutlet weak var licenceTextView: LicenceTextView!
    
    
    private var item: DefaultNavigationItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNav()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func initNav() {
        self.title = "ライセンス"
        self.item = DefaultNavigationItem(item: self.navigationItem)
        self.item?.addLeftItem(type: .close) {
            self.close()
        }
    }
    
    
    private func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
