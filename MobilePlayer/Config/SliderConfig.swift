//
//  SliderConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/15/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

class SliderConfig {
  let identifier: String?
  let trackHeight: CGFloat
  let trackCornerRadius: CGFloat
  let minimumTrackTintColor: UIColor
  let availableTrackTintColor: UIColor
  let maximumTrackTintColor: UIColor
  let thumbTintColor: UIColor
  let thumbWidth: CGFloat
  let thumbHeight: CGFloat
  let thumbCornerRadius: CGFloat
  let thumbBorderWidth: CGFloat
  let thumbBorderColor: CGColor

  convenience init() {
    self.init(dictionary: [String: AnyObject]())
  }

  init(dictionary: [String: AnyObject]) {
    identifier = dictionary["identifier"] as? String
    trackHeight = (dictionary["trackHeight"] as? CGFloat) ?? 4
    trackCornerRadius = (dictionary["trackCornerRadius"] as? CGFloat) ?? 2

    if let minimumTrackTintColorHex = dictionary["minimumTrackTintColor"] as? String {
      minimumTrackTintColor = UIColor(hex: minimumTrackTintColorHex)
    } else {
      minimumTrackTintColor = UIColor.blueColor()
    }

    if let availableTrackTintColorHex = dictionary["availableTrackTintColor"] as? String {
      availableTrackTintColor = UIColor(hex: availableTrackTintColorHex)
    } else {
      availableTrackTintColor = UIColor.grayColor()
    }

    if let maximumTrackTintColorHex = dictionary["maximumTrackTintColor"] as? String {
      maximumTrackTintColor = UIColor(hex: maximumTrackTintColorHex)
    } else {
      maximumTrackTintColor = UIColor.darkGrayColor()
    }

    if let thumbTintColorHex = dictionary["thumbTintColor"] as? String {
      thumbTintColor = UIColor(hex: thumbTintColorHex)
    } else {
      thumbTintColor = UIColor.lightGrayColor()
    }

    thumbWidth = (dictionary["thumbWidth"] as? CGFloat) ?? 22
    thumbHeight = (dictionary["thumbHeight"] as? CGFloat) ?? 22
    thumbCornerRadius = (dictionary["thumbCornerRadius"] as? CGFloat) ?? 11
    thumbBorderWidth = (dictionary["thumbBorderWidth"] as? CGFloat) ?? (1 / UIScreen.mainScreen().scale)

    if let thumbBorderColorHex = dictionary["thumbBorderColor"] as? String {
      thumbBorderColor = UIColor(hex: thumbBorderColorHex).CGColor
    }
  }
}
