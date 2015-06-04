//
//  CloseButtonConfig.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 27/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct CloseButtonConfig {
  var closeButtonImage = MovielalaPlayerConfig.loadImage(named: "MLCloseButton.png")
  var closeButtonTintColor = UIColor.whiteColor()
  
  public init() {}
  
  public init(dictionary: [String: AnyObject]) {
    if let closeButtonImageName = dictionary["image"] as? String {
      closeButtonImage = MovielalaPlayerConfig.loadImage(named: closeButtonImageName)
    }
    if let closeButtonTintColorHex = dictionary["tintColor"] as? String {
      closeButtonTintColor = UIColor(hexString: closeButtonTintColorHex)
    }
  }
}
