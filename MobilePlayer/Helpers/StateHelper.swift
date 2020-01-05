//
//  StateHelper.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 8/6/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

struct StateHelper {
    static func calculateStateUsing(
        previousState: MobilePlayerViewController.State,
        andPlaybackState playbackState: AVPlayer.TimeControlStatus) -> MobilePlayerViewController.State {
        
        switch playbackState {
        case .paused:
            return .paused
        case .playing:
            return .playing
        case .waitingToPlayAtSpecifiedRate:
            return .buffering
            
        @unknown default:
            #if DEBUG
            fatalError("StateHelper: Handle all cases from AVPlayer.TimeControlStatus")
            #else
            print("IMPORTANT: Handle all cases from AVPlayer.TimeControlStatus")
            return .idle
            #endif
            
        }
    }
}
