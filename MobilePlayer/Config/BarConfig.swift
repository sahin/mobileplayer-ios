//
//  BarConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/15/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

public struct BarConfig {
  public let backgroundColor: [UIColor]
  public let height: CGFloat
  public let topBorderHeight: CGFloat
  public let topBorderColor: UIColor
  public let bottomBorderHeight: CGFloat
  public let bottomBorderColor: UIColor
  public let elements: [ElementConfig]

  public convenience init() {
    self.init(dictionary: [String: AnyObject]())
  }

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
      backgroundColor = UIColor(white: 0, alpha: 0.7)
    }

    height = (dictionary["height"] as? CGFloat) ?? 40
    topBorderHeight = (dictionary["topBorderHeight"] as? CGFloat) ?? 1

    if let topBorderColorHex = dictionary["topBorderColor"] as? String {
      topBorderColor = UIColor(hex: topBorderColorHex)
    } else {
      topBorderColor = UIColor(white: 1, alpha: 0.2)
    }

    bottomBorderHeight = (dictionary["bottomBorderHeight"] as? CGFloat) ?? 1

    if let bottomBorderColorHex = dictionary["bottomBorderColor"] as? String {
      bottomBorderColor = UIColor(hex: bottomBorderColorHex)
    } else {
      bottomBorderColor = UIColor(white: 1, alpha: 0.2)
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
    }
  }
}
