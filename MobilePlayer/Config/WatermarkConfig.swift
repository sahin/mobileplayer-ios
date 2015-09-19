//
//  WatermarkConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/18/15.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit

public enum WatermarkPosition: String {
  case center = "center"
  case top = "top"
  case topRight = "topRight"
  case right = "right"
  case bottomRight = "bottomRight"
  case bottom = "bottom"
  case bottomLeft = "bottomLeft"
  case left = "left"
  case topLeft = "topLeft"
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
      position = .bottomRight
    }
  }
}
