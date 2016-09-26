//
//  StateHelper.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 8/6/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MediaPlayer

struct StateHelper {

  static func calculateStateUsing(
    previousState: MobilePlayerViewController.State,
    andPlaybackState playbackState: MPMoviePlaybackState) -> MobilePlayerViewController.State {
      switch playbackState {
      case .stopped:
        return .idle
      case .playing:
        return .playing
      case .paused:
        return .paused
      case .interrupted:
        return .buffering
      case .seekingForward, .seekingBackward:
        return previousState
      }
  }
}
