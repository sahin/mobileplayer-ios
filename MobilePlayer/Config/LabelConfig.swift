//
//  LabelConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/15/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

public class LabelConfig: ElementConfig {
  public let text: String?
  public let font: UIFont
  public let textColor: UIColor

  public convenience init() {
    self.init(dictionary: [String: AnyObject]())
  }

  public override init(dictionary: [String: AnyObject]) {
    text = dictionary["text"] as? String

    let fontName = dictionary["font"] as? String
    let size = (dictionary["size"] as? CGFloat) ?? ((dictionary["identifier"] as? String) == "title" ? 16 : 14)
    if let fontName = fontName, font = UIFont(name: fontName, size: size) {
      self.font = font
    } else {
      font = UIFont.systemFontOfSize(size)
    }

    if let textColorHex = dictionary["textColor"] as? String {
      textColor = UIColor(hex: textColorHex)
    } else {
      textColor = UIColor.whiteColor()
    }

    super.init(dictionary: dictionary)
  }
}
