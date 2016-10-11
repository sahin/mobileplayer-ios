//
//  ToggleButtonConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/15/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

/// Holds toggle button configuration values.
public class ToggleButtonConfig: ElementConfig {

  /// Button height. Default value is 40.
  public let height: CGFloat

  /// Button image when it's not toggled.
  public let image: UIImage?

  /// Button tint color when it's not toggled. Default value is white.
  public let tintColor: UIColor

  /// Button image when it's toggled.
  public let toggledImage: UIImage?

  /// Button tint color when it's toggled. Default value is white.
  public let toggledTintColor: UIColor

  /// Initializes using default values.
  public convenience init() {
    self.init(dictionary: [String: Any]())
  }

  /// Initializes using a dictionary.
  ///
  /// * Key for `height` is `"height"` and its value should be a number.
  /// * Key for `image` is `"image"` and its value should be an image asset name.
  /// * Key for `tintColor` is `"tintColor"` and its value should be a color hex string.
  /// * Key for `toggledImage` is `"toggledImage"` and its value should be an image asset name.
  /// * Key for `toggledTintColor` is `"toggledTintColor"` and its value should be a color hex string.
  ///
  /// - parameters:
  ///   - dictionary: Toggle button configuration dictionary.
  public override init(dictionary: [String: Any]) {
    // Values need to be AnyObject for type conversions to work correctly.
    let dictionary = dictionary as [String: AnyObject]
    
    let identifier = dictionary["identifier"] as? String
    
    height = (dictionary["height"] as? CGFloat) ?? 40
    
    if let imageName = dictionary["image"] as? String {
      image = UIImage(named: imageName)
    } else if identifier == "play" {
      image = UIImage(podResourceNamed: "MLPlayButton")?.template
    } else {
      image = nil
    }

    if let tintColorHex = dictionary["tintColor"] as? String {
      tintColor = UIColor(hex: tintColorHex)
    } else {
      tintColor = UIColor.white
    }

    if let toggledImageName = dictionary["toggledImage"] as? String {
      toggledImage = UIImage(named: toggledImageName)
    } else if identifier == "play" {
      toggledImage = UIImage(podResourceNamed: "MLPauseButton")?.template
    } else {
      toggledImage = nil
    }
    
    if let toggledTintColorHex = dictionary["toggledTintColor"] as? String {
      toggledTintColor = UIColor(hex: toggledTintColorHex)
    } else {
      toggledTintColor = UIColor.white
    }

    super.init(dictionary: dictionary)
  }
}
