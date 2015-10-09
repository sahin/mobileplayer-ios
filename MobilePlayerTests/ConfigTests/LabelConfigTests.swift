//
//  LabelConfigTests.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 08/10/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit
import XCTest
@testable import MobilePlayer

private let defaultText: String? = nil
private let text = "lorem ipsum"

private let font = "Baskerville"

private let defaultSize = CGFloat(14)
private let defaultTitleSize = CGFloat(16)
private let size = CGFloat(22)

private let defaultColor = UIColor.whiteColor()
private let colorString = "#fffffff0"
private let color = UIColor(red: 1, green: 1, blue: 1, alpha: 240 / 255)

class LabelConfigTests: XCTestCase {
  let defaultLabelConfig = LabelConfig()
  let defaultTitleLabelConfig = LabelConfig(dictionary: ["identifier": "title"])
  let labelConfig = LabelConfig(dictionary: [
    "text": text,
    "font": font,
    "size": size,
    "textColor": colorString])

  func testText() {
    XCTAssert(defaultLabelConfig.text == defaultText, "default text is wrong")
    XCTAssert(labelConfig.text == text, "failed to set text")
  }

  func testFont() {
    XCTAssert(defaultLabelConfig.font == UIFont.systemFontOfSize(defaultSize), "default font is wrong")
    XCTAssert(defaultTitleLabelConfig.font == UIFont.systemFontOfSize(defaultTitleSize), "default title font is wrong")
    XCTAssert(labelConfig.font == UIFont(name: font, size: size), "failed to set font")
  }

  func testTextColor() {
    XCTAssert(defaultLabelConfig.textColor == defaultColor, "default text color is wrong")
    XCTAssert(labelConfig.textColor == color, "failed to set text color")
  }
}
