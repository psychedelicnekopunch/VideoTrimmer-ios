
import UIKit
import Photos
import PryntTrimmerView

class VTViewController: UIViewController, TrimmerViewDelegate {
    
    @IBOutlet weak var videoPlayerView: VTVideoPlayerView!
    @IBOutlet weak var trimmerView: TrimmerView!
    
    @IBOutlet weak var playerButton: DefaultButton!
    @IBOutlet weak var trimmingButton: DefaultButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var asset: PHAsset?
    
    var avAsset: AVAsset?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNav()
        self.initPlayer()
        self.initButton()
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        // parent = nil の時が navigationItem の戻るボタンで戻った時
        if parent == nil {
            videoPlayerView.finish()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func initNav() {
        self.title = "Video"
    }
    
    
    private func initPlayer() {
        timeLabel.text = ""
        trimmerView.minDuration = 1.0
        trimmerView.maxDuration = 9.5
        trimmerView.delegate = self
        self.asset?.toAVAsset { (asset: AVAsset?) in
            if let a: AVAsset = asset {
                self.timeLabel.text = a.duration.seconds.toFormatedString()
                self.avAsset = a
                DispatchQueue.main.async {
                    self.videoPlayerView.prepare(asset: a)
                    self.trimmerView.asset = a
                }
            }
        }
    }
    
    
    private func initButton() {
        playerButton.touchDown = {
            if self.videoPlayerView.isPause {
                self.videoPlayerView.resume()
            } else {
                self.videoPlayerView.pause()
            }
        }
        trimmingButton.touchDown = {
            if let asset: AVAsset = self.avAsset {
                print("start export")
                VideoExporter.sharedInstance.export(asset: asset, start: self.videoPlayerView.startTime, end: self.videoPlayerView.endTime, volume: 1.0) { (error: Bool, message: String) in
                    print(message)
                    if error {
                        return
                    }
                    self.close()
                }
            }
        }
    }
    
    
    private func close() {
        self.dismiss(animated: true) {
            self.videoPlayerView.finish()
        }
    }
    
    
    // MARK: - TrimmerViewDelegate
    
    func didChangePositionBar(_ playerTime: CMTime) {
        self.videoPlayerView.pause()
        if let startTime: CMTime = trimmerView.startTime, let endTime: CMTime = trimmerView.endTime {
            let diff: Double = endTime.seconds - startTime.seconds
            timeLabel.text = diff.toFormatedString()
            self.videoPlayerView.seek(to: playerTime)
            self.videoPlayerView.startTime = startTime
            self.videoPlayerView.endTime = endTime
        }
    }
    
    
    func positionBarStoppedMoving(_ playerTime: CMTime) {
        if let startTime: CMTime = trimmerView.startTime, let endTime: CMTime = trimmerView.endTime {
            let diff: Double = endTime.seconds - startTime.seconds
            timeLabel.text = diff.toFormatedString()
            self.videoPlayerView.seek(to: playerTime)
            self.videoPlayerView.startTime = startTime
            self.videoPlayerView.endTime = endTime
        }
    }
    
}
