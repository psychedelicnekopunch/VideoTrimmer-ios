
import UIKit
import AVFoundation

/*
 https://qiita.com/edo_m18/items/cf3a183ad73bb711b195
 https://qiita.com/masapp/items/dd0589d2a894a2a32b82
 
 1. 合成を実行するAVMutableCompositionオブジェクトを作る
 2. AVAssetオブジェクトの生成と、オブジェクトから動画部分と音声部分のトラック情報をそれぞれ取得する
 3. トラック合成用のAVMutableCompositionTrackを、AVMutableCompositionから生成する
 4. (3)で生成したトラックに動画・音声を登録する
 5. 動画の合成命令用オブジェクトを生成（AVMutableVideoCompositionInstructionとAVMutableVideoCompositionLayerInstruction）
 6. 動画合成オブジェクト（AVMutableVideoComposition）を生成
 7. 音声合成用パラメータオブジェクトの生成（AVMutableAudioMixInputParameters）
 8. 音声合成用オブジェクトを生成（AVMutableAudioMix）
 9. 動画情報（AVAssetTrack）から回転状態を判別する
 10. 回転情報を元に、合成、生成する動画のサイズを決定する
 11. 合成動画の情報を設定する
 12. 動画出力用オブジェクトを生成する
 13. 保存設定を行い、Exportを実行
 */

class VideoExporter {
    
    var outputUrl: URL {
        get {
            return self.to
        }
    }
    
    private var outputFileType: AVFileType = .mp4
    
    private var to: URL
    
    var quality: String = AVAssetExportPreset1280x720
    
    var startTime: CMTime?
    
    var endTime: CMTime?
    
    var volume: Float = 1.0
    
    var views: [UIView] = [UIView]()
    
    
    init(to: URL) {
        self.to = to
    }
    
    init(to: URL, type: AVFileType) {
        self.to = to
        self.outputFileType = type
    }
    
    
    public func export(asset: AVAsset, completion: @escaping (_ error: Bool, _ message: String) -> Void) {
        self.export(urlAsset: asset as! AVURLAsset) { (error: Bool, message: String) in
            completion(error, message)
        }
    }
    
    
    public func export(url: URL, completion: @escaping (_ error: Bool, _ message: String) -> Void) {
        let asset: AVURLAsset = AVURLAsset(url: url, options: nil)
        self.export(urlAsset: asset) { (error: Bool, message: String) in
            completion(error, message)
        }
    }
    
    
    public func export(urlAsset asset: AVURLAsset, completion: @escaping (_ error: Bool, _ message: String) -> Void) {
        
        // 動画削除
        let file: FileManager = FileManager()
        do {
            try? file.removeItem(at: self.to)
        }
        
        let startTime: CMTime = (self.startTime == nil) ? kCMTimeZero : self.startTime!
        let endTime: CMTime = (self.endTime == nil) ? asset.duration : self.endTime!
        let timeRange: CMTimeRange = CMTimeRange(start: startTime, end: endTime)
        
        print(startTime.seconds, endTime.seconds)
        
        // 1. 合成を実行するAVMutableCompositionオブジェクトを作る
        let mutableComposition: AVMutableComposition = AVMutableComposition()
        
        // 2. AVAssetオブジェクトの生成と、オブジェクトから動画部分と音声部分のトラック情報をそれぞれ取得する
        if asset.tracks(withMediaType: .video).count == 0 {
            completion(true, "動画のエクスポートに失敗しました")
            return
        }
        
        let videoTrack: AVAssetTrack = asset.tracks(withMediaType: .video)[0]
        var audioTrackTemp: AVAssetTrack?
        
        // 音声トラックがない動画の場合がある
        if asset.tracks(withMediaType: .audio).count > 0 {
            audioTrackTemp = asset.tracks(withMediaType: .audio)[0]
        }
        
        // 3. トラック合成用のAVMutableCompositionTrackを、AVMutableCompositionから生成する
        guard let compositionVideoTrack: AVMutableCompositionTrack = mutableComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            completion(true, "failed: addMutableTrack(.video)")
            return
        }
        
        var compositionAudioTrack: AVMutableCompositionTrack?
        
        if self.volume > 0 {
            if let _: AVAssetTrack = audioTrackTemp {
                compositionAudioTrack = mutableComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            }
        }
        
        // 4. (3)で生成したトラックに動画・音声を登録する
        try? compositionVideoTrack.insertTimeRange(timeRange, of: videoTrack, at: kCMTimeZero)
        
        if self.volume > 0 {
            if let audioTrack: AVAssetTrack = audioTrackTemp {
                try? compositionAudioTrack?.insertTimeRange(timeRange, of: audioTrack, at: kCMTimeZero)
            }
        }
        
        // 9. 動画情報（AVAssetTrack）から回転状態を判別する
        // 動画の回転情報を取得する
        let tf: CGAffineTransform = videoTrack.preferredTransform
        
        // Portrait = 縦向き
        let isPortrait: Bool = (tf.a == 0 && tf.d == 0 && (tf.b == 1.0 || tf.b == -1.0) && (tf.c == 1.0 || tf.c == -1.0))
            ? true : false
        
        // 10. 回転情報を元に、合成、生成する動画のサイズを決定する
        let originVideoSize: CGSize = videoTrack.naturalSize
        let videoSize: CGSize = (isPortrait)
            ? CGSize(width: originVideoSize.height, height: originVideoSize.width)
            : originVideoSize
        
        // 5. 動画の合成命令用オブジェクトを生成（AVMutableVideoCompositionInstructionとAVMutableVideoCompositionLayerInstruction）
        let instruction: AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, endTime - startTime)
        let layerInstruction: AVMutableVideoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack)
        
        // 動画が縦向きだったら90度回転させる
        if isPortrait {
            let tf1: CGAffineTransform = CGAffineTransform(translationX: originVideoSize.height, y: 0)
            let tf2: CGAffineTransform = tf1.rotated(by: CGFloat(Double.pi / 2))
            // setTransform(CGAffineTransform, at: CMTime)
            layerInstruction.setTransform(tf2, at: kCMTimeZero)
        }
        
        instruction.layerInstructions = [layerInstruction]
        
        // 6. 動画合成オブジェクト（AVMutableVideoComposition）を生成
        let videoComposition: AVMutableVideoComposition = AVMutableVideoComposition()
        videoComposition.instructions = [instruction]
        
        // 7. 音声合成用パラメータオブジェクトの生成（AVMutableAudioMixInputParameters）
        var audioMixInputParameters: AVMutableAudioMixInputParameters?
        if self.volume > 0 {
            if let _: AVAssetTrack = audioTrackTemp {
                audioMixInputParameters = AVMutableAudioMixInputParameters(track: compositionAudioTrack)
                audioMixInputParameters?.setVolumeRamp(fromStartVolume: self.volume, toEndVolume: self.volume, timeRange: CMTimeRangeMake(kCMTimeZero, mutableComposition.duration))
            }
        }
        
        // 8. 音声合成用オブジェクトを生成（AVMutableAudioMix）
        let audioMix: AVMutableAudioMix = AVMutableAudioMix()
        
        if let mix: AVMutableAudioMixInputParameters = audioMixInputParameters {
            if let _: AVAssetTrack = audioTrackTemp {
                audioMix.inputParameters = [mix]
            }
        }
        
        // xx. 途中追加処理 (画像を合成するための準備)
        // 親レイヤーを作成
        let parentLayer: CALayer = CALayer()
        let videoLayer: CALayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
        parentLayer.addSublayer(videoLayer)
        
        // 動画に重ねる画像を追加
        for view in views {
            if let image: UIImage = view.toImage() {
                let minScale: CGFloat = CGFloat(min(Double(image.size.width / videoSize.width), Double(image.size.height / videoSize.height)))
                let width: CGFloat = videoSize.width * minScale
                let height: CGFloat = videoSize.height * minScale
                let x: CGFloat = (image.size.width - width) / 2
                let y: CGFloat = (image.size.height - height) / 2
                let frame: CGRect = CGRect(x: x, y: y, width: width, height: height)
                let imageLayer: CALayer = CALayer()
                imageLayer.contents = image.cropping(to: frame)?.cgImage
                imageLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
                // Ratina対応
                imageLayer.contentsScale = UIScreen.main.scale
                parentLayer.addSublayer(imageLayer)
            }
        }
        
        // 11. 合成動画の情報を設定する
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTimeMake(1, 30)
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
        
        // 12. 動画出力用オブジェクトを生成する
        // 画質 (AVAssetExportPreset)
        guard let exportSession: AVAssetExportSession = AVAssetExportSession(asset: mutableComposition, presetName: self.quality) else {
            completion(true, "failed: AVAssetExportSession.init")
            return
        }
        
        // 13. 保存設定を行い、Exportを実行
        exportSession.videoComposition = videoComposition
        exportSession.audioMix = audioMix
        exportSession.outputFileType = self.outputFileType
        exportSession.outputURL = self.to
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously(completionHandler: {
            switch exportSession.status {
            case .completed:
                completion(false, "success")
            case .cancelled:
                completion(true, "cancelled: export")
            case .exporting:
                completion(true, "exporting: export")
            case .failed:
                completion(true, "failed: export")
            case .unknown:
                completion(true, "unknown: export")
            case .waiting:
                completion(true, "waiting: export")
            }
            
        })
    }
    
}
