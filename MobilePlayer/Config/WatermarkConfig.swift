//
//  WatermarkConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/18/15.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit

public enum WatermarkPosition: String {
  case Center = "center"
  case Top = "top"
  case TopRight = "topRight"
  case Right = "right"
  case BottomRight = "bottomRight"
  case Bottom = "bottom"
  case BottomLeft = "bottomLeft"
  case Left = "left"
  case TopLeft = "topLeft"
}

public class WatermarkConfig {
  public let image: UIImage?
  public let position: WatermarkPosition

  public convenience init() {
    self.init(dictionary: [String: AnyObject]())
  }

  public init(dictionary: [String: AnyObject]) {
    if let imageName = dictionary["image"] as? String {
      image = UIImage(named: imageName)
    } else {
      image = nil
    }
    if let
      positionString = dictionary["position"] as? String,
      positionValue = WatermarkPosition(rawValue: positionString) {
        position = positionValue
    } else {
      position = .BottomRight
    }
  }
}
