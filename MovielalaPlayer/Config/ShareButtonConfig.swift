//
//  ShareConfig.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 26/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct ShareButtonConfig {
  
  // MARK: - Special Callbacks
  var shareCallback: ((playerVC: MovielalaPlayerViewController) -> Void)? = nil
  
  // MARK: - Theming
  var shareButtonImage = MovielalaPlayerConfig.loadImage(named: "MLShareButton.png")
  var shareButtonTintColor = UIColor.whiteColor()
  
  public init() {}
  
  public init(dictionary: [String: AnyObject]) {
    if let shareButtonImageName = dictionary["image"] as? String {
      self.shareButtonImage = MovielalaPlayerConfig.loadImage(named: shareButtonImageName)
    }
    if let shareButtonTintColor = dictionary["tintColor"] as? String {
      self.shareButtonTintColor = UIColor(hexString: shareButtonTintColor)
    }
  }
}
