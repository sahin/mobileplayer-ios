//
//  CloseButtonConfig.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 27/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct CloseButtonConfig {
  public var imageName = MobilePlayerConfig.loadImage(named: "MLCloseButton.png").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
  public var tintColor = UIColor.whiteColor()
  public var backgroundColor = UIColor.clearColor()

  public init() {}

  public init(array: [AnyObject]) {
    for item in array {
      if item["name"] as? String == "close" {
        if let imageName = item["image"] as? String {
          self.imageName = MobilePlayerConfig.loadImage(named: imageName).imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }
        if let tintColorHex = item["tintColor"] as? String {
          self.tintColor = UIColor(hexString: tintColorHex)
        }
        if let backgroundColorHex = item["backgroundColor"] as? String {
          self.backgroundColor = UIColor(hexString: backgroundColorHex)
        }
      }

    }
  }
}
