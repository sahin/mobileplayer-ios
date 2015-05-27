//
//  TitleConfig.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 27/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct TitleConfig {
  var titleTextFont = UIFont.systemFontOfSize(14)
  var titleTextColor = UIColor(hexString: "#ffffff")
  var titleBackgroundColor = UIColor(hexString: "#000000")
  
  public init() {}
  
  public init(dictionary: [String: AnyObject]) {
    if let titleConfig = dictionary["title"] as? [String:AnyObject] {
      if let titleTextFont = titleConfig["titleTextFont"] as? String {
        if let titleTextSize = titleConfig["titleTextSize"] as? CGFloat {
          self.titleTextFont = UIFont(name: titleTextFont, size: titleTextSize)!
        }
      }
      if let titleBackgroundColor = titleConfig["titleBackgroundColor"] as? String {
        self.titleBackgroundColor = UIColor(hexString: titleBackgroundColor)
      }
    }
  }
}
