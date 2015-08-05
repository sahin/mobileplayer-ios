//
//  TitleConfig.swift
//  MobilePlayer
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

  public init(array: [[String:AnyObject]]) {
    for item in array {
      if let subtype = item["subType"] as? String {
        switch subtype {
        case "title":
          if let textFontValue = item["textFont"] as? String {
            if let textSizeValue = item["textSize"] as? CGFloat {
              self.textFont = UIFont(name: textFontValue, size: textSizeValue)!
            }
          }
          if let backgroundColorHex = item["backgroundColor"] as? String {
            self.backgroundColor = UIColor(hexString: backgroundColorHex)
          }
          if let textColorHex = item["textColor"] as? String {
            self.textColor = UIColor(hexString: textColorHex)
          }
        default:
          println("")
        }
      }
    }
  }
}
