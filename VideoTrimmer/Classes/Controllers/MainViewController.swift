
import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var openButton: DefaultButton!
    
    @IBOutlet weak var licenceButton: DefaultButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func initButton() {
        openButton.touchDown = {
            self.gotoHome()
        }
        licenceButton.touchDown = {
            self.gotoLicence()
        }
    }
    
    
    private func gotoHome() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Thumbnail", bundle: nil)
        let vc: ThumbnailViewController = storyboard.instantiateViewController(withIdentifier: "Thumbnail") as! ThumbnailViewController
        let nav: DefaultNavigationController = DefaultNavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    private func gotoLicence() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Licence", bundle: nil)
        let vc: LicenceViewController = storyboard.instantiateViewController(withIdentifier: "Licence") as! LicenceViewController
        let nav: DefaultNavigationController = DefaultNavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
}
