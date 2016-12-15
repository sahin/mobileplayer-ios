//
//  StateHelper.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 8/6/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import AVFoundation

struct StateHelper {

    static func calculateStateUsing(
        previousState: MobilePlayerViewController.State,
        andPlaybackState playbackState: AVPlayerStatus) -> MobilePlayerViewController.State {
        switch playbackState {
        case .unknown:
            return .idle
        case .readyToPlay:
            return .playing
        case .failed:
            return .buffering
        }
    }

}

