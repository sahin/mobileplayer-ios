//
//  SliderConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/15/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

public class SliderConfig: ElementConfig {
  public let trackHeight: CGFloat
  public let trackCornerRadius: CGFloat
  public let minimumTrackTintColor: UIColor
  public let availableTrackTintColor: UIColor
  public let maximumTrackTintColor: UIColor
  public let thumbTintColor: UIColor
  public let thumbWidth: CGFloat
  public let thumbHeight: CGFloat
  public let thumbCornerRadius: CGFloat
  public let thumbBorderWidth: CGFloat
  public let thumbBorderColor: CGColor

  public convenience init() {
    self.init(dictionary: [String: AnyObject]())
  }

  public override init(dictionary: [String: AnyObject]) {
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
    } else {
      thumbBorderColor = UIColor.blackColor().CGColor
    }

    super.init(dictionary: dictionary)
  }
}
