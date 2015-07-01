//
//  MobilePlayerStateManager.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 23/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

public var playerStateHistory: [PlayerState] = []

enum MoviePlayerState: Int {
  // Playback State
  case Stopped
  case Playing
  case Pause
  case Interrupted
  case SeekingForward
  case SeekingBackward
  // Load State
  case Unknown
  case Playable
  case PlaythroughOK
  case Stalled
  case Buffering
}

public enum PlayerState: Int {
  case Buffering
  case Idle
  case Complete
  case Paused
  case Playing
  case Error
  case Loading
  case Stalled
  case Unknown
}

public class MobilePlayerStateManager  {
  init() {
    playerStateHistory.reserveCapacity(2)
  }
}

var moviePlayerState: MoviePlayerState = .Unknown {
didSet{
  switch (moviePlayerState){
  case MoviePlayerState.Pause:
    playerState = PlayerState.Paused
  case MoviePlayerState.Interrupted:
    playerState = PlayerState.Error
  case MoviePlayerState.SeekingForward:
    playerState = PlayerState.Playing
  case MoviePlayerState.SeekingBackward:
    playerState = PlayerState.Playing
  case MoviePlayerState.Unknown:
    playerState = PlayerState.Idle
  case MoviePlayerState.Playable:
    playerState = PlayerState.Idle
  case MoviePlayerState.PlaythroughOK:
    playerState = PlayerState.Idle
  case MoviePlayerState.Stopped:
    playerState = PlayerState.Complete
  case MoviePlayerState.Buffering:
    playerState = PlayerState.Buffering
  case MoviePlayerState.Stalled:
    playerState = PlayerState.Stalled
  case MoviePlayerState.Playing:
    playerState = PlayerState.Playing
  case MoviePlayerState.Unknown:
    playerState = PlayerState.Unknown
  case MoviePlayerState.Playing:
    playerState = PlayerState.Playing
  default:
    break
  }
}
}

public var playerState: PlayerState = .Unknown {
didSet {
  if playerStateHistory.count > 2 {
    playerStateHistory.insert(playerState, atIndex: 0)
    println("\(playerStateHistory[0].hashValue) - \(playerStateHistory[1].hashValue)")
  } else {
    playerStateHistory.append(playerState)
  }
}
}
