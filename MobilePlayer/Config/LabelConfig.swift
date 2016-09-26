//
//  LabelConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/15/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

/// Holds label configuration values.
public class LabelConfig: ElementConfig {

  /// Initial text for the label.
  public let text: String?

  /// Label font. Default value is system font of size 14 (16 if `identifier` is `"title"`).
  public let font: UIFont

  /// Color of the text. Default value is white.
  public let textColor: UIColor

  /// Initializes using default values.
  public convenience init() {
    self.init(dictionary: [String: Any]())
  }

  /// Initializes using a dictionary.
  ///
  /// * Key for `text` is `"text"` and its value should be a string.
  /// * Keys for `font` are `"font"` and `"size"`; value of `"font"` should be a font name, and `"size"` should be a
  /// number.
  /// * Key for `textColor` is `"textColor"` and its value should be a color hex string.
  ///
  /// - parameters:
  ///   - dictionary: Label configuration dictionary.
  public override init(dictionary: [String: Any]) {
    // Values need to be AnyObject for type conversions to work correctly.
    let dictionary = dictionary as [String: AnyObject]
    
    text = dictionary["text"] as? String

    let fontName = dictionary["font"] as? String
    let size = (dictionary["size"] as? CGFloat) ?? ((dictionary["identifier"] as? String) == "title" ? 16 : 14)
    if let fontName = fontName, let font = UIFont(name: fontName, size: size) {
      self.font = font
    } else {
      font = UIFont.systemFont(ofSize: size)
    }

    if let textColorHex = dictionary["textColor"] as? String {
      textColor = UIColor(hex: textColorHex)
    } else {
      textColor = UIColor.white
    }

    super.init(dictionary: dictionary)
  }
}
