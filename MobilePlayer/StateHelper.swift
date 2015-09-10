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
      case .Stopped:
        return .Idle
      case .Playing:
        return .Playing
      case .Paused:
        return .Paused
      case .Interrupted:
        return .Buffering
      case .SeekingForward, .SeekingBackward:
        return previousState
      }
  }
}
