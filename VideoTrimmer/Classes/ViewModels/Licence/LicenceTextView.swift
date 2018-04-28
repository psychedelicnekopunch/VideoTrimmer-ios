
import UIKit
import SwiftyMarkdown

class LicenceTextView: UITextView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.text = ""
        self.isEditable = false
        if let path: String = Bundle.main.path(forResource: "Acknowledgements", ofType: "md") {
            if let data = NSData(contentsOfFile: path) {
                if let text: String = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) as String? {
                    let md: SwiftyMarkdown = SwiftyMarkdown(string: text)
                    self.attributedText = md.attributedString()
                }
            }
        }
    }
}
