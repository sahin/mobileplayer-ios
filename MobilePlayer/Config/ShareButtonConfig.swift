//
//  ShareButtonConfig.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 26/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct ShareButtonConfig {

  // MARK: - Theming
  public var imageName = MobilePlayerConfig.loadImage(named: "MLShareButton.png").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
  public var tintColor = UIColor.whiteColor()
  public var backgroundColor = UIColor.clearColor()

  public init() {}

  public init(array: [AnyObject]) {
    for item in array {
      if item["name"] as? String == "share" {
        if let imageNameValue = item["image"] as? String {
          self.imageName = MobilePlayerConfig.loadImage(named: imageNameValue).imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }
        if let tintColorHex = item["tintColor"] as? String {
          self.tintColor = UIColor(hexString: tintColorHex)
        }
        if let backgroundColorValue = item["backgroundColor"] as? String {
          self.backgroundColor = UIColor(hexString: backgroundColorValue)
        }
      }
    }
  }
}
