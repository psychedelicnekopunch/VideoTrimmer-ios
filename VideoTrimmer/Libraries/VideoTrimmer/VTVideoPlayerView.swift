
import UIKit
import AVFoundation

class VTVideoPlayerView: UIView {
    
    private var asset: AVAsset?
    
    private var item: AVPlayerItem?
    
    var player: AVPlayer? {
        get {
            return self.playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    private var playerLayer: AVPlayerLayer {
        get {
            return self.layer as! AVPlayerLayer
        }
    }
    
    var didPause: (() -> Void)?
    
    var didPlay: (() -> Void)?
    
    var progress: ((_ progressPercent: CGFloat) -> Void)?
    
    var startTime: CMTime = kCMTimeZero
    
    var endTime: CMTime = kCMTimeZero
    
    var isPause: Bool = false
    
    private var promise: Timer?
    
    private var myContext: Int = 0
    
    // UIView のサブクラスを作り layerClass をオーバーライドして AVPlayerLayer に差し替える
    override class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.black
    }
    
    
    private func addObserver() {
        self.player?.addObserver(self, forKeyPath: "rate", options: .new, context: &self.myContext)
        if self.promise == nil {
            self.promise = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.playing(_:)), userInfo: nil, repeats: true)
        }
    }
    
    private func removeObserver() {
        self.player?.removeObserver(self, forKeyPath: "rate")
        NotificationCenter.default.removeObserver(self)
        self.promise?.invalidate()
        self.promise = nil
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &self.myContext {
            if keyPath == "rate" {
                if let rate: Float = player?.rate {
                    switch rate {
                    case 0.0:// pause
                        self.isPause = true
                        self.didPause?()
                    case 1.0:// play
                        self.isPause = false
                        self.didPlay?()
                    default:
                        break
                    }
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    func prepare(asset: AVAsset) {
        let videoPlayers = self.getPlayers(asset: asset)
        self.asset = asset
        self.endTime = asset.duration
        self.player = videoPlayers
        self.player?.actionAtItemEnd = .none
        // 再生 / ポーズの判定を監視する
        self.addObserver()
        self.player?.play()
    }
    
    func resume() {
        self.player?.play()
    }
    
    
    func pause() {
        self.player?.pause()
    }
    
    
    func seek(to: CMTime) {
        self.player?.seek(to: to)
    }
    
    
    private func next() {
        self.player?.seek(to: self.startTime)
    }
    
    
    private func getPlayers(asset: AVAsset) -> AVPlayer {
        self.item = AVPlayerItem(asset: asset)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPlay(_:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: item)
//        self.playerLayer.videoGravity = .resizeAspectFill
        self.playerLayer.videoGravity = .resizeAspect
        return AVPlayer(playerItem: self.item)
    }
    
    
    func finish() {
        self.removeObserver()
        self.player = nil
    }
    
    
    // MARK: - Notification
    
    @objc func didPlay(_ sender: Notification) {
        print("did play")
        self.next()
    }
    
    
    // MARK: - Timer
    
    @objc func playing(_ sender: Timer) {
        guard let item: AVPlayerItem = self.player?.currentItem else {
            return
        }
        guard let currentTime: Double = self.player?.currentTime().seconds else {
            return
        }
        let durationSec: Int = Int(item.duration.seconds * 1000)
        let progressPercentTemp: Double = (currentTime * 1000) / Double(durationSec)
        var progressPercent: CGFloat = CGFloat(progressPercentTemp * 1.05)
        
        progressPercent = (progressPercent > 1) ? 1 : progressPercent
        
        self.progress?(progressPercent)
        
        if self.isPause {
            return
        }
        
        if self.endTime.seconds <= currentTime {
            self.seek(to: self.startTime)
        }
    }
    
}
