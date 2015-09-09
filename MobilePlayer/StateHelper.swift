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

  static func stateForPlaybackState(
    playbackState: MPMoviePlaybackState,
    andLoadState loadState: MPMovieLoadState) -> MobilePlayerViewController.State {
      var state: MobilePlayerViewController.State
      // MPMoviePlaybackState
      switch (playbackState){
      case MPMoviePlaybackState.Interrupted:
        state = .Error
      case MPMoviePlaybackState.Paused:
        state = .Paused
      case MPMoviePlaybackState.Playing:
        state = .Playing
      case MPMoviePlaybackState.SeekingBackward:
        state = .SeekingBackward
      case MPMoviePlaybackState.SeekingForward:
        state = .SeekingForward
      case MPMoviePlaybackState.Stopped:
        state = .Complete
      default:
        break
      }
      // MPMoviePlaybackState
      switch (loadState){
      case MPMovieLoadState.Playable:
        state = .Idle
      case MPMovieLoadState.PlaythroughOK:
        state = .Idle
      case MPMovieLoadState.Stalled:
        state = .Stalled
      case MPMovieLoadState.Unknown:
        state = .Unknown
      default:
        break
      }
      return state
  }
}
