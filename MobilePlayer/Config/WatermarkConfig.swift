//
//  WatermarkConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/18/15.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit

/// Indicates the position of watermark in content area.
public enum WatermarkPosition: String {

  /// Place watermark at the center.
  case Center = "center"

  /// Place watermark at the top edge, centered horizontally.
  case Top = "top"

  /// Place watermark at the top right corner.
  case TopRight = "topRight"

  /// Place watermark at the right edge, centered vertically.
  case Right = "right"

  /// Place watermark at the bottom right corner.
  case BottomRight = "bottomRight"

  /// Place watermark at the bottom edge, centered horizontally.
  case Bottom = "bottom"

  /// Place watermark at the bottom left corner.
  case BottomLeft = "bottomLeft"

  /// Place watermark at the left edge, centered vertically.
  case Left = "left"

  /// Place watermark at the top left corner.
  case TopLeft = "topLeft"
}

/// Holds watermark configuration values. 
public class WatermarkConfig {

  /// Watermark image.
  public let image: UIImage?

  /// Watermark position. Default value is `.BottomRight`.
  public let position: WatermarkPosition

  /// Initializes using default values.
  public convenience init() {
    self.init(dictionary: [String: Any]())
  }

  /// Initializes using a dictionary.
  ///
  /// * Key for `image` is `"image"` and its value should be an image asset name.
  /// * Key for `position` is `"position"` and its value should be a raw `WaterMarkPosition` enum value.
  ///
  /// - parameters:
  ///   - dictionary: Watermark configuration dictionary.
  public init(dictionary: [String: Any]) {
    // Values need to be AnyObject for type conversions to work correctly.
    let dictionary = dictionary as [String: AnyObject]
    
    if let imageName = dictionary["image"] as? String {
      image = UIImage(named: imageName)
    } else {
      image = nil
    }
    if
      let positionString = dictionary["position"] as? String,
      let positionValue = WatermarkPosition(rawValue: positionString) {
        position = positionValue
    } else {
      position = .BottomRight
    }
  }
}
