//
//  CloseButtonConfig.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 27/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct CloseButtonConfig {
  
  // MARK: - Title
  
  var closeButtonImage = MovielalaPlayerConfig.loadImage(named: "MLCloseButton")
  var closeButtonTintColor = UIColor.whiteColor()
  
  public init() {}
  
  public init(dictionary: [String: AnyObject]) {
    if let closeButtonImage = dictionary["image"] as? String {
      self.closeButtonImage = MovielalaPlayerConfig.loadImage(named: closeButtonImage)
    }
    if let closeButtonTintColor = dictionary["tintColor"] as? String {
      self.closeButtonTintColor = UIColor(rgba: closeButtonTintColor)
    }
  }
  
}
