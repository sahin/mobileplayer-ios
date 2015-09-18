//
//  ElementConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/17/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public class ElementConfig {
  public let type: String?
  public let identifier: String?
  public let marginLeft: CGFloat
  public let marginRight: CGFloat

  public convenience init() {
    self.init(dictionary: [String: AnyObject]())
  }

  public init(dictionary: [String: AnyObject]) {
    type = dictionary["type"] as? String
    identifier = dictionary["identifier"] as? String
    marginLeft = (dictionary["marginLeft"] as? CGFloat) ?? 0
    marginRight = (dictionary["marginRight"] as? CGFloat) ?? 0
  }
}
