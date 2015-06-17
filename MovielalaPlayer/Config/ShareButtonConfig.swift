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
  public var imageName = MovielalaPlayerConfig.loadImage(named: "MLShareButton.png")
  public var tintColor = UIColor.whiteColor()
  public var backgroundColor = UIColor.clearColor()

  public init() {}

  public init(dictionary: [String: AnyObject]) {
    if let imageName = dictionary["image"] as? String {
      self.imageName = MovielalaPlayerConfig.loadImage(named: imageName)
    }
    if let tintColor = dictionary["tintColor"] as? String {
      self.tintColor = UIColor(hexString: tintColor)
    }
    if let backgroundColor = dictionary["backgroundColor"] as? String {
      self.backgroundColor = UIColor(hexString: backgroundColor)
    }
  }
}
