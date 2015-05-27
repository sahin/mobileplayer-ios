//
//  CloseConfig.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 27/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct CloseConfig {
  var closeButtonImage = MovielalaPlayerConfig.loadImage(named: "MLCloseButton")
  var closeButtonTintColor = UIColor.whiteColor()
  
  public init() {}
  
  public init(dictionary: [String: AnyObject]) {
    // Close Button
    if let closeButtonConfig = dictionary["closeButton"] as? [String:AnyObject] {
      if let closeButtonImage = closeButtonConfig["image"] as? String {
        self.closeButtonImage = MovielalaPlayerConfig.loadImage(named: closeButtonImage)
      }
      if let closeButtonTintColor = closeButtonConfig["tintColor"] as? String {
        self.closeButtonTintColor = UIColor(rgba: closeButtonTintColor)
      }
    }
  }
}
