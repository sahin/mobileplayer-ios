//
//  SliderConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/15/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

/// Holds slider configuration values.
public class SliderConfig: ElementConfig {

  /// Height of the slider track.
  public let trackHeight: CGFloat

  /// Corner radius of the slider track.
  public let trackCornerRadius: CGFloat

  /// Color of the track to the left of slider thumb.
  public let minimumTrackTintColor: UIColor

  /// Color of the parts of the track which fall to the right side of slider thumb and represent available value
  /// (e.g. buffered duration of a video).
  public let availableTrackTintColor: UIColor

  /// Color of the track to the right of slider thumb.
  public let maximumTrackTintColor: UIColor

  /// Color of the slider thumb.
  public let thumbTintColor: UIColor

  /// Width of the slider thumb.
  public let thumbWidth: CGFloat

  /// Height of the slider thumb.
  public let thumbHeight: CGFloat

  /// Corner radius of the slider thumb.
  public let thumbCornerRadius: CGFloat

  /// Border width of the slider thumb.
  public let thumbBorderWidth: CGFloat

  /// Border color of the slider thumb.
  public let thumbBorderColor: CGColor

  /// Initializes using default values.
  public convenience init() {
    self.init(dictionary: [String: AnyObject]())
  }

  /// Initializes using a dictionary.
  ///
  /// * Key for `trackHeight` is `"trackHeight"` and its value should be a number.
  /// * Key for `trackCornerRadius` is `"trackCornerRadius"` and its value should be a number.
  /// * Key for `minimumTrackTintColor` is `"minimumTrackTintColor"` and its value should be a color hex string.
  /// * Key for `availableTrackTintColor` is `"availableTrackTintColor"` and its value should be a color hex string.
  /// * Key for `maximumTrackTintColor` is `"maximumTrackTintColor"` and its value should be a color hex string.
  /// * Key for `thumbTintColor` is `"thumbTintColor"` and its value should be a color hex string.
  /// * Key for `thumbWidth` is `"thumbWidth"` and its value should be a number.
  /// * Key for `thumbHeight` is `"thumbHeight"` and its value should be a number.
  /// * Key for `thumbCornerRadius` is `"thumbCornerRadius"` and its value should be a number.
  /// * Key for `thumbBorderWidth` is `"thumbBorderWidth"` and its value should be a number.
  /// * Key for `thumbBorderColor` is `"thumbBorderColor"` and its value should be a color hex string.
  ///
  /// - parameters:
  ///   - dictionary: Toggle button configuration dictionary.
  public override init(dictionary: [String: AnyObject]) {
    trackHeight = (dictionary["trackHeight"] as? CGFloat) ?? 6
    trackCornerRadius = (dictionary["trackCornerRadius"] as? CGFloat) ?? 3

    if let minimumTrackTintColorHex = dictionary["minimumTrackTintColor"] as? String {
      minimumTrackTintColor = UIColor(hex: minimumTrackTintColorHex)
    } else {
      minimumTrackTintColor = UIColor(white: 0.9, alpha: 1)
    }

    if let availableTrackTintColorHex = dictionary["availableTrackTintColor"] as? String {
      availableTrackTintColor = UIColor(hex: availableTrackTintColorHex)
    } else {
      availableTrackTintColor = UIColor(white: 0.6, alpha: 1)
    }

    if let maximumTrackTintColorHex = dictionary["maximumTrackTintColor"] as? String {
      maximumTrackTintColor = UIColor(hex: maximumTrackTintColorHex)
    } else {
      maximumTrackTintColor = UIColor(white: 0.3, alpha: 1)
    }

    if let thumbTintColorHex = dictionary["thumbTintColor"] as? String {
      thumbTintColor = UIColor(hex: thumbTintColorHex)
    } else {
      thumbTintColor = UIColor.whiteColor()
    }

    thumbWidth = (dictionary["thumbWidth"] as? CGFloat) ?? 16
    thumbHeight = (dictionary["thumbHeight"] as? CGFloat) ?? 16
    thumbCornerRadius = (dictionary["thumbCornerRadius"] as? CGFloat) ?? 8
    thumbBorderWidth = (dictionary["thumbBorderWidth"] as? CGFloat) ?? 0

    if let thumbBorderColorHex = dictionary["thumbBorderColor"] as? String {
      thumbBorderColor = UIColor(hex: thumbBorderColorHex).CGColor
    } else {
      thumbBorderColor = UIColor.clearColor().CGColor
    }

    super.init(dictionary: dictionary)
  }
}
