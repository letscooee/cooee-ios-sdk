//
//  VideoView.swift
//  shaadicardmaker
//
//  Created by Surbhi Lath on 28/07/20.
//  Copyright © 2020 codenicely. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

class VideoView: UIView {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    var avpController = AVPlayerViewController()
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
   
    func configure(url: String) {
        if let videoURL = URL(string: url) {
//            player = AVPlayer(url: videoURL)
//            playerLayer = AVPlayerLayer(player: player)
//
//            playerLayer?.videoGravity = AVLayerVideoGravity.resize
//            if let playerLayer = self.playerLayer {
//                layer.addSublayer(playerLayer)
//            }
//
//            self.layoutIfNeeded()
//            playerLayer?.bounds = bounds
            player = AVPlayer(url: videoURL)
            avpController.player = player
            avpController.view.frame.size.height = self.frame.size.height
            avpController.view.frame.size.width = self.frame.size.width
            avpController.view.backgroundColor = .clear
            avpController.videoGravity = .resizeAspectFill
//            avpController.showsPlaybackControls = false
//            let playPauseButton = PlayPauseButton()
//            playPauseButton.avPlayer = player
//            self.addSubview(playPauseButton)
//            playPauseButton.setup()
//            self.addSubview(avpController.view)
//            self.layoutIfNeeded()
//            avpController.showsPlaybackControls = false
            self.addSubview(avpController.view)
            avpController.view.bounds = self.bounds
            self.layoutIfNeeded()
            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        }
    }
    
    func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player?.play()
        }

        avpController.player?.play()
    
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if isLoop {
            player?.pause()
            player?.seek(to: CMTime.zero)
            player?.play()
        }
    }
}
