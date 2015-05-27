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
  var shareButtonImage = MovielalaPlayerConfig.loadImage(named: "MLShareButton")
  var shareButtonTintColor = UIColor.whiteColor()
  
  public init() {}
  
  public init(dictionary: [String: AnyObject]) {
      if let shareButtonImage = dictionary["image"] as? String {
        self.shareButtonImage = MovielalaPlayerConfig.loadImage(named: shareButtonImage)
      }
      if let shareButtonTintColor = dictionary["tintColor"] as? String {
        self.shareButtonTintColor = UIColor(rgba: shareButtonTintColor)
      }
  }
}
