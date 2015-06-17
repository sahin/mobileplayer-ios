//
//  CloseButtonConfig.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 27/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct CloseButtonConfig {
  public var imageName = MovielalaPlayerConfig.loadImage(named: "MLCloseButton.png")
  public var tintColor = UIColor.whiteColor()
  public var backgroundColor = UIColor.clearColor()

  public init() {}

  public init(dictionary: [String: AnyObject]) {
    if let imageName = dictionary["image"] as? String {
      self.imageName = MovielalaPlayerConfig.loadImage(named: imageName)
    }
    if let tintColorHex = dictionary["tintColor"] as? String {
      self.tintColor = UIColor(hexString: tintColorHex)
    }
    if let backgroundColorHex = dictionary["backgroundColor"] as? String {
      self.backgroundColor = UIColor(hexString: backgroundColorHex)
    }
  }
}
