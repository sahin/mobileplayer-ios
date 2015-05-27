//
//  ControlbarConfig.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 26/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation


public struct ControlbarConfig {
  
  var playButtonImage = MovielalaPlayerConfig.loadImage(named: "MLPlayButton")
  var playButtonTintColor = UIColor.whiteColor()
  var pauseButtonImage = MovielalaPlayerConfig.loadImage(named: "MLPauseButton")
  var pauseButtonTintColor = UIColor.whiteColor()
  var timeTextFont = UIFont.systemFontOfSize(14)
  var timeTextColor = UIColor.whiteColor()
  
  public init() {}
  
  public init(dictionary: [String: AnyObject]) {
   
    // Play Button
    if let playButtonConfig = dictionary["playButton"] as? [String:AnyObject] {
      if let playButtonImage = playButtonConfig["image"] as? String {
        self.playButtonImage = MovielalaPlayerConfig.loadImage(named: playButtonImage)
      }
      if let playButtonTintColor = playButtonConfig["tintColor"] as? String {
        self.playButtonTintColor = UIColor(rgba: playButtonTintColor)
      }
    }
    
    // Pause Button
    if let pauseButtonConfig = dictionary["pauseButton"] as? [String:AnyObject] {
      if let pauseButtonImage = pauseButtonConfig["image"] as? String {
        self.pauseButtonImage = MovielalaPlayerConfig.loadImage(named: pauseButtonImage)
      }
      if let pauseButtonTintColor = pauseButtonConfig["tintColor"] as? String {
        self.pauseButtonTintColor = UIColor(rgba: pauseButtonTintColor)
      }
    }
    
    // Time
    if let timeConfig = dictionary["time"] as? [String:AnyObject] {
      if let timeTextFont = timeConfig["textFont"] as? String {
        if let timeTextSize = timeConfig["textFontSize"] as? CGFloat {
        self.timeTextFont = UIFont(name: timeTextFont, size: timeTextSize)!
        }
      }
      if let timeTextColor = timeConfig["textColor"] as? String {
        self.timeTextColor = UIColor(rgba: timeTextColor)
      }
    }
    
    // Time Slider
    // TODO: Add Time Slider Component value
    
    
  }
  
}
