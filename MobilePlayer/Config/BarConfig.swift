//
//  BarConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/15/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

/// Holds bar configuration values.
public class BarConfig {

  /// Bar background color. If there is more than one value, background will be a gradient.
  public let backgroundColor: [UIColor]

  /// Bar height.
  public let height: CGFloat

  /// Height of the top edge border view.
  public let topBorderHeight: CGFloat

  /// Background color of the top edge border view.
  public let topBorderColor: UIColor

  /// Height of the bottom edge border view.
  public let bottomBorderHeight: CGFloat

  /// Background color of the bottom edge border view.
  public let bottomBorderColor: UIColor

  /// An array of configuration objects for the elements of the bar.
  public let elements: [ElementConfig]

  /// Initializes using default values.
  public convenience init() {
    self.init(dictionary: [String: AnyObject]())
  }

  /// Initializes using a dictionary.
  ///
  /// * Key for `backgroundColor` is `"backgroundColor"` colors and its value should either be a color hex string, or an array
  /// of color hex strings for a gradient background.
  /// * Key for `height` is `"height"` and its value should be a number.
  /// * Key for `topBorderHeight` is `"topBorderHeight"` and its value should be a number.
  /// * Key for `topBorderColor` is `"topBorderColor"` and its value should be a color hex string.
  /// * Key for `bottomBorderHeight is `"bottomBorderHeight"` and its value should be a number.
  /// * Key for `bottomBorderColor` is `"bottomBorderColor"` and its value should be a color hex string.
  /// * Key for `elements` is `"elements"` and its value should be an array of element configuration dictionaries.
  ///
  /// - parameters:
  ///   - dictionary: Bar configuration dictionary.
  public init(dictionary: [String: AnyObject]) {
    if let backgroundColorHexes = dictionary["backgroundColor"] as? [String] {
      var colors = [UIColor]()
      for hex in backgroundColorHexes {
        colors.append(UIColor(hex: hex))
      }
      backgroundColor = colors
    } else if let backgroundColorHex = dictionary["backgroundColor"] as? String {
      backgroundColor = [UIColor(hex: backgroundColorHex)]
    } else {
      backgroundColor = [UIColor(white: 0, alpha: 0.7)]
    }

    height = (dictionary["height"] as? CGFloat) ?? 40
    topBorderHeight = (dictionary["topBorderHeight"] as? CGFloat) ?? 0

    if let topBorderColorHex = dictionary["topBorderColor"] as? String {
      topBorderColor = UIColor(hex: topBorderColorHex)
    } else {
      topBorderColor = UIColor.clearColor()
    }

    bottomBorderHeight = (dictionary["bottomBorderHeight"] as? CGFloat) ?? 0

    if let bottomBorderColorHex = dictionary["bottomBorderColor"] as? String {
      bottomBorderColor = UIColor(hex: bottomBorderColorHex)
    } else {
      bottomBorderColor = UIColor.clearColor()
    }

    if let elementDictionaries = dictionary["elements"] as? [[String: AnyObject]] {
      var validElements = [ElementConfig]()
      for elementDictionary in elementDictionaries {
        if let type = elementDictionary["type"] as? String {
          switch type {
          case "button":
            validElements.append(ButtonConfig(dictionary: elementDictionary))
          case "toggleButton":
            validElements.append(ToggleButtonConfig(dictionary: elementDictionary))
          case "label":
            validElements.append(LabelConfig(dictionary: elementDictionary))
          case "slider":
            validElements.append(SliderConfig(dictionary: elementDictionary))
          default:
            break
          }
        }
      }
      elements = validElements
    } else {
      elements = []
    }
  }
}
