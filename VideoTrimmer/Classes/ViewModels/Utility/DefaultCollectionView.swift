
import UIKit

class DefaultCollectionView: UICollectionView, UICollectionViewDelegate {
    
    var didSelectItemAt: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void)?
    
    var didOverScrollTop: (() -> Void)?
    var willOverScrollBottom: (() -> Void)?
    
    private var isValidScroll: Bool = true
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectItemAt?(collectionView, indexPath)
    }
    
    
    // MARK: - Scroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isDragging {
            if self.contentOffset.y < -30 {
                if !self.isValidScroll {
                    self.didOverScrollTop?()
                }
                return
            }
            if self.contentOffset.y < 0 {
                if self.isValidScroll {
                    let offset: CGPoint = CGPoint(x: 0, y: 0)
                    self.setContentOffset(offset, animated: false)
                    self.isValidScroll = false
                }
                return
            }
            if self.contentOffset.y > 0 {
                self.isValidScroll = true
            }
            if self.contentOffset.y + self.frame.height > self.contentSize.height - 200 {
                self.willOverScrollBottom?()
            }
        }
    }
    
}
