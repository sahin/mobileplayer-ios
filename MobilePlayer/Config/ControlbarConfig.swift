//
//  ControlbarConfig.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 26/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct ControlbarConfig {

  public var playButtonImage = MobilePlayerConfig.loadImage(named: "MLPlayButton.png")
  public var playButtonTintColor = UIColor.whiteColor()
  public var playButtonBackgroundColor = UIColor.clearColor()
  public var pauseButtonImage = MobilePlayerConfig.loadImage(named: "MLPauseButton.png")
  public var pauseButtonTintColor = UIColor.whiteColor()
  public var timeTextFont = UIFont.systemFontOfSize(14)
  public var timeTextColor = UIColor.whiteColor()
  public var timeBackgroundColor = UIColor.clearColor()
  public var durationTextFont = UIFont.systemFontOfSize(14)
  public var durationTextColor = UIColor.whiteColor()
  public var durationBackgroundColor = UIColor.clearColor()
  public var timeSliderRailTintColor = UIColor.lightGrayColor()
  public var timeSliderBufferTintColor = UIColor.grayColor()
  public var timeSliderProgressTintColor = UIColor.blueColor()
  public var timeSliderThumbTintColor = UIColor.whiteColor()
  public var timeSliderBackgroundColor = UIColor.clearColor()
  public var volumeButtonImage = MobilePlayerConfig.loadImage(named: "MLVolumeButton.png")
  public var volumeBackgroundColor = UIColor.clearColor()
  public var volumeTintColor = UIColor.blackColor()
  public var volumeProgressTintColor = UIColor.blueColor()
  public var volumeThumbTintColor = UIColor.grayColor()
  public var volumeRailTintColor = UIColor.whiteColor()
  public var backgroundColor = UIColor.clearColor()
  private var components:[String] = []

  public init() {}

  public func getComponents() -> [String]?{
    return components
  }

  public init(dictionary: [String: AnyObject]) {
    if let playButtonConfig = dictionary["playButton"] as? [String:AnyObject] {
      components.append("playButton")
      if let playButtonImageValue = playButtonConfig["image"] as? String {
        playButtonImage = MobilePlayerConfig.loadImage(named: playButtonImageValue)
      }
      if let playButtonTintColorValue = playButtonConfig["tintColor"] as? String {
        playButtonTintColor = UIColor(hexString: playButtonTintColorValue)
      }
      if let playButtonBackgroundColorValue = playButtonConfig["backgroundColor"] as? String {
        playButtonBackgroundColor = UIColor(hexString: playButtonBackgroundColorValue)
      }
    }
    if let pauseButtonConfig = dictionary["pauseButton"] as? [String:AnyObject] {
      if let pauseButtonImageValue = pauseButtonConfig["image"] as? String {
        pauseButtonImage = MobilePlayerConfig.loadImage(named: pauseButtonImageValue)
      }
      if let pauseButtonTintColorValue = pauseButtonConfig["tintColor"] as? String {
        pauseButtonTintColor = UIColor(hexString: pauseButtonTintColorValue)
      }
    }
    if let backgroundColorValue = dictionary["backgroundColor"] as? String {
      backgroundColor = UIColor(hexString: backgroundColorValue)
    }
    if let timeConfig = dictionary["timeLabel"] as? [String:AnyObject] {
      components.append("timeLabel")
      if let timeTextFontValue = timeConfig["textFont"] as? String {
        if let timeTextSizeValue = timeConfig["textFontSize"] as? CGFloat {
          timeTextFont = UIFont(name: timeTextFontValue, size: timeTextSizeValue)!
        }
      }
      if let timeTextColorValue = timeConfig["textColor"] as? String {
        timeTextColor = UIColor(hexString: timeTextColorValue)
      }
      if let timeBackgroundColorValue = timeConfig["backgroundColor"] as? String {
        timeBackgroundColor = UIColor(hexString: timeBackgroundColorValue)
      }
    }
    if let durationConfig = dictionary["durationLabel"] as? [String:AnyObject] {
      components.append("durationLabel")
      if let durationTextFontValue = durationConfig["textFont"] as? String {
        if let durationTextSizeValue = durationConfig["textFontSize"] as? CGFloat {
          durationTextFont = UIFont(name: durationTextFontValue, size: durationTextSizeValue)!
        }
      }
      if let durationTextColorValue = durationConfig["textColor"] as? String {
        durationTextColor = UIColor(hexString: durationTextColorValue)
      }
      if let durationBackgroundColorValue = durationConfig["backgroundColor"] as? String {
        durationBackgroundColor = UIColor(hexString: durationBackgroundColorValue)
      }
    }
    if let timeSliderConfig = dictionary["timeSlider"] as? [String:AnyObject] {
      components.append("timeSlider")
      if let timeSliderRailTintColorValue = timeSliderConfig["railTintColor"] as? String {
        timeSliderRailTintColor = UIColor(hexString: timeSliderRailTintColorValue)
      }
      if let timeSliderBufferTintColorValue = timeSliderConfig["bufferTintColor"] as? String {
        timeSliderBufferTintColor = UIColor(hexString: timeSliderBufferTintColorValue)
      }
      if let timeSliderProgressTintColorValue = timeSliderConfig["progressTintColor"] as? String {
        timeSliderProgressTintColor = UIColor(hexString: timeSliderProgressTintColorValue)
      }
      if let timeSliderThumbTintColorValue = timeSliderConfig["thumbTintColor"] as? String {
        timeSliderThumbTintColor = UIColor(hexString: timeSliderThumbTintColorValue)
      }
      if let timeSliderBackgroundColorValue = timeSliderConfig["backgroundColor"] as? String {
        timeSliderBackgroundColor = UIColor(hexString: timeSliderBackgroundColorValue)
      }
    }
    if let volumeSliderConfig = dictionary["volumeSlider"] as? [String:AnyObject] {
      components.append("volumeSlider")
      if let volumeSliderRailTintColorValue = volumeSliderConfig["railTintColor"] as? String {
        volumeRailTintColor = UIColor(hexString: volumeSliderRailTintColorValue)
      }
      if let volumeSliderProgressTintColorValue = volumeSliderConfig["progressTintColor"] as? String {
        volumeProgressTintColor = UIColor(hexString: volumeSliderProgressTintColorValue)
      }
      if let volumeSliderThumbTintColorValue = volumeSliderConfig["thumbTintColor"] as? String {
        volumeThumbTintColor = UIColor(hexString: volumeSliderThumbTintColorValue)
      }
      if let volumeSliderBackgroundColorValue = volumeSliderConfig["backgroundColor"] as? String {
        volumeBackgroundColor = UIColor(hexString: volumeSliderBackgroundColorValue)
      }
      if let volumeButtonImageValue = volumeSliderConfig["buttonImage"] as? String {
        volumeButtonImage = MobilePlayerConfig.loadImage(named: volumeButtonImageValue)
      }
      if let volumeTintColorValue = volumeSliderConfig["tintColor"] as? String {
        volumeTintColor = UIColor(hexString: volumeTintColorValue)
      }
    }
  }
}
