//
//  ControlbarConfig.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 26/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct ControlbarConfig {

  public var playButtonImage = MobilePlayerConfig.loadImage(named: "MLPlayButton.png").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
  public var playButtonTintColor = UIColor.whiteColor()
  public var playButtonBackgroundColor = UIColor.clearColor()
  public var pauseButtonImage = MobilePlayerConfig.loadImage(named: "MLPauseButton.png").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
  public var pauseButtonTintColor = UIColor.whiteColor()
  public var timeTextFont = UIFont.systemFontOfSize(14)
  public var timeTextColor = UIColor.whiteColor()
  public var timeBackgroundColor = UIColor.clearColor()
  public var durationTextFont = UIFont(name: "HelveticaNeue", size: 14)
  public var durationTextColor = UIColor.whiteColor()
  public var durationBackgroundColor = UIColor.blackColor()
  public var timeSliderRailTintColor = UIColor.lightGrayColor()
  public var timeSliderBufferTintColor = UIColor.grayColor()
  public var timeSliderProgressTintColor = UIColor.blueColor()
  public var timeSliderThumbTintColor = UIColor.whiteColor()
  public var timeSliderBackgroundColor = UIColor.clearColor()
  public var volumeButtonImage = MobilePlayerConfig.loadImage(named: "MLVolumeButton.png").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
  public var volumeBackgroundColor = UIColor.clearColor()
  public var volumeTintColor = UIColor.blackColor()
  public var volumeProgressTintColor = UIColor.blueColor()
  public var volumeThumbTintColor = UIColor.grayColor()
  public var volumeRailTintColor = UIColor.whiteColor()
  public var backgroundColor = UIColor.clearColor()

  public init() {}

  public init(array: [AnyObject]) {
    for item in array {
      if item["name"] as? String == "play" {
        // Play Button
        if let playButtonImageValue = item["playImage"] as? String {
          playButtonImage = MobilePlayerConfig.loadImage(named: playButtonImageValue)
        }
        if let playButtonTintColorValue = item["playTintColor"] as? String {
          playButtonTintColor = UIColor(hexString: playButtonTintColorValue)
        }
        if let playButtonBackgroundColorValue = item["backgroundColor"] as? String {
          playButtonBackgroundColor = UIColor(hexString: playButtonBackgroundColorValue)
        }
        if let pauseButtonImageValue = item["pauseImage"] as? String {
          pauseButtonImage = MobilePlayerConfig.loadImage(named: pauseButtonImageValue)
        }
        if let pauseButtonTintColorValue = item["pauseTintColor"] as? String {
          pauseButtonTintColor = UIColor(hexString: pauseButtonTintColorValue)
        }
      }
      if item["name"] as? String == "time" {
        // Time Label
        if let timeTextFontValue = item["textFont"] as? String {
          if let timeTextSizeValue = item["textFontSize"] as? CGFloat {
            timeTextFont = UIFont(name: timeTextFontValue, size: timeTextSizeValue)!
          }
        }
        if let timeTextColorValue = item["textColor"] as? String {
          timeTextColor = UIColor(hexString: timeTextColorValue)
        }
        if let timeBackgroundColorValue = item["backgroundColor"] as? String {
          timeBackgroundColor = UIColor(hexString: timeBackgroundColorValue)
        }
      }
      if item["name"] as? String == "duration" {
        // Duration Label
        if let durationTextFontValue = item["textFont"] as? String {
          if let durationTextSizeValue = item["textFontSize"] as? CGFloat {
            durationTextFont = UIFont(name: durationTextFontValue, size: durationTextSizeValue)!
          }
        }
        if let durationTextColorValue = item["textColor"] as? String {
          durationTextColor = UIColor(hexString: durationTextColorValue)
        }
        if let timeBackgroundColorValue = item["backgroundColor"] as? String {
          durationBackgroundColor = UIColor(hexString: timeBackgroundColorValue)
        }
      }
      if item["name"] as? String == "timeSlider" {
        // TimeSlider View
        if let timeSliderRailTintColorValue = item["railTintColor"] as? String {
          timeSliderRailTintColor = UIColor(hexString: timeSliderRailTintColorValue)
        }
        if let timeSliderBufferTintColorValue = item["bufferTintColor"] as? String {
          timeSliderBufferTintColor = UIColor(hexString: timeSliderBufferTintColorValue)
        }
        if let timeSliderProgressTintColorValue = item["progressTintColor"] as? String {
          timeSliderProgressTintColor = UIColor(hexString: timeSliderProgressTintColorValue)
        }
        if let timeSliderThumbTintColorValue = item["thumbTintColor"] as? String {
          timeSliderThumbTintColor = UIColor(hexString: timeSliderThumbTintColorValue)
        }
        if let timeSliderBackgroundColorValue = item["backgroundColor"] as? String {
          timeSliderBackgroundColor = UIColor(hexString: timeSliderBackgroundColorValue)
        }
      }
      if item["name"] as? String == "volume" {
        // VolumeSlider View
        if let volumeSliderRailTintColorValue = item["railTintColor"] as? String {
          volumeRailTintColor = UIColor(hexString: volumeSliderRailTintColorValue)
        }
        if let volumeSliderProgressTintColorValue = item["progressTintColor"] as? String {
          volumeProgressTintColor = UIColor(hexString: volumeSliderProgressTintColorValue)
        }
        if let volumeSliderThumbTintColorValue = item["thumbTintColor"] as? String {
          volumeThumbTintColor = UIColor(hexString: volumeSliderThumbTintColorValue)
        }
        if let volumeSliderBackgroundColorValue = item["backgroundColor"] as? String {
          volumeBackgroundColor = UIColor(hexString: volumeSliderBackgroundColorValue)
        }
        if let volumeButtonImageValue = item["buttonImage"] as? String {
          volumeButtonImage = MobilePlayerConfig.loadImage(named: volumeButtonImageValue)
        }
        if let volumeTintColorValue = item["tintColor"] as? String {
          volumeTintColor = UIColor(hexString: volumeTintColorValue)
        }
      }
    }
  }
}
