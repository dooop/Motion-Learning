//
//  AnimationViewController.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 24.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class AnimationViewController : UIViewController {

    private var videos = [MotionType: AVPlayer]()
    
    private var currentVideo: (type: MotionType, player: AVPlayer, layer: AVPlayerLayer)? {
        willSet {
            if newValue == nil {
                currentVideo?.layer.removeFromSuperlayer()
                recentLayers.forEach({ $0.removeFromSuperlayer() })
                recentLayers.removeAll()
            }
        }
        
        didSet {
            NotificationCenter.default.removeObserver(self)

            if let video = currentVideo {
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(restartAnimation),
                                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                       object: video.player.currentItem)
            }
        }
    }
    
    private var recentLayers = [AVPlayerLayer]() {
        willSet {
            recentLayers.first?.removeFromSuperlayer()
        }
    }
    
    private func updateVideo(with player: AVPlayer, and type: MotionType) {
        if let recentLayer = currentVideo?.layer {
            recentLayers.append(recentLayer)
        }
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.opacity = 0
        view.layer.addSublayer(playerLayer)
        playerLayer.fade(to: 1)
        
        currentVideo = (type: type, player: player, layer: playerLayer)
        restartAnimation()
    }
    
    func loadAnimations() {
        guard let standingAnimationPath = Bundle.main.path(forResource: "standingAnimation", ofType:"mp4"),
            let walkingAnimationPath = Bundle.main.path(forResource: "walkingAnimation", ofType:"mp4") else {
                return
        }
        
        videos[.standing] = AVPlayer(url: URL(fileURLWithPath: standingAnimationPath))
        videos[.walking] = AVPlayer(url: URL(fileURLWithPath: walkingAnimationPath))
    }
    
    func restartAnimation() {
        self.currentVideo?.player.seek(to: kCMTimeZero)
        self.currentVideo?.player.play()
    }
    
    func showAnimation(for type: MotionType?) {
        guard currentVideo?.type != type else {
            return
        }
        
        guard let type = type, let player = videos[type] else {
            currentVideo = nil
            return
        }
        
        updateVideo(with: player, and: type)
    }
}
