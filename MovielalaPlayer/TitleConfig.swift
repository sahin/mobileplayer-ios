//
//  TitleConfig.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 27/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct TitleConfig {
  public var textFont = UIFont.systemFontOfSize(14)
  public var textColor = UIColor(hexString: "#ffffff")
  public var backgroundColor = UIColor.clearColor()

  public init() { }

  public init(dictionary: [String: AnyObject]) {
    if let textFont = dictionary["textFont"] as? String {
      if let textSize = dictionary["textSize"] as? CGFloat {
        self.textFont = UIFont(name: textFont, size: textSize)!
      }
    }
    if let backgroundColor = dictionary["backgroundColor"] as? String {
      self.backgroundColor = UIColor(hexString: backgroundColor)
    }
    if let textColor = dictionary["textColor"] as? String {
      self.textColor = UIColor(hexString: textColor)
    }
  }
}
