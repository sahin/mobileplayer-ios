//
//  PlayerView.swift
//  MobilePlayer
//
//  Created by Ferhat Abdullahoglu on 5.01.2020.
//  Copyright © 2020 MovieLaLa. All rights reserved.
//

import Foundation
import AVKit

/// Relays the status info from the playerItem
public protocol PlayerItemStatusDelegate: AnyObject {
    func statusDidChange(_ status: AVPlayerItem.Status, item: AVPlayerItem)
    
    func playerDidFinish(_ player: AVPlayer)
    
    func cycleDidMove(_ player: AVPlayer, time: CMTime)
}


/// A UIView subclass that comes with its own
/// AVPlayerLayer
public class PlayerView: UIView {
    
    // MARK: - Public properties
    /// Player
    ///
    /// An AVPlayer object can directly be set but once the URL is set, this will override
    /// the previously set AVPlayer and will initialize a new player pointing to the URL
    public var player: AVPlayer! {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
            
            // check the periodic observer as well
            if let token = playerPeriodicObserver {
                playerLayer.player?.removeTimeObserver(token)
                playerPeriodicObserver = nil
            }
            
            playerLayer.player = newValue
            playerLayer.player?.currentItem?.addObserver(self,
                                                         forKeyPath: #keyPath(AVPlayerItem.status),
                                                         options: [.old, .new],
                                                         context: &self.itemStatusObserver)
            
            playerLayer.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main, using: {[weak self] (time) in
                guard let self = self else { return }
                self.observePlayerPeriodically(time)
            })
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(didPlayUntilEnd(_:)),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: nil)
        }
    }
    
    
    /// Player status delegate
    public weak var delegate: PlayerItemStatusDelegate?
    
    
    /// A new AVPlayer will be initialized upon setting the URL
    public var url: URL? {
        didSet {
            if let _url = url {
                player = AVPlayer(url: _url)
            }
        }
    }
    
    /// Content backing layer 
    public var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override public static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    // MARK: - Private methods
    /// AVPlayerItemDidPlayUntilEnd notification handler
    /// - Parameter notification: Notification
    @objc
    private func didPlayUntilEnd(_ notification: Notification) {
        guard let _player = self.player else { return }
        delegate?.playerDidFinish(_player)
    }
    
    private func observePlayerPeriodically(_ time: CMTime) {
        guard let _player = self.player else { return }
        delegate?.cycleDidMove(_player, time: time)
    }
    
    // MARK: - Initialization
    deinit {
        NotificationCenter.default.removeObserver(self)
        player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        
        // check the periodic observer as well
        if let token = playerPeriodicObserver {
            playerLayer.player?.removeTimeObserver(token)
            playerPeriodicObserver = nil
        }

    }
    
    // MARK: - KVO
    // Status KVO
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // make sure the notification is meant for us
        guard context == &self.itemStatusObserver else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            guard let item = playerLayer.player?.currentItem else { return }
            delegate?.statusDidChange(status, item: item)
            
        }
    }
    
    // MARK: - Private properties
    /// Player item status KVO obsver context
    private var itemStatusObserver: Int = 1
    
    /// Player item periodic observer
    private var playerPeriodicObserver: Any!
    
}
