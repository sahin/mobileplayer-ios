//
//  StateHelper.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 8/6/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MediaPlayer

class StateHelper: MobilePlayerViewController {

  static func stateForPlayer(player: MPMoviePlayerController) -> MobilePlayerViewController.State {
    var state: MobilePlayerViewController.State
    // MPMoviePlaybackState
    switch (player.playbackState){
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
    switch (player.loadState){
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
