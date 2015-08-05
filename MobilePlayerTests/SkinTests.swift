//
//  SkinTests.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 8/3/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import XCTest
import MobilePlayer

class SkinTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  // controlbar tests

  func testPlayPauseButton() {
    let fileURL = NSBundle(forClass: SkinTests.self).URLForResource("Skin", withExtension:"json")!
    let skin = SkinParser.parseConfigFromURL(fileURL)
    if let skinDictionary = skin?.skinDictionary as [String: AnyObject]? {
      if let controlbar = skinDictionary["controlbar"] as? [[String: AnyObject]] {
        if let order = controlbar[0]["order"] as? Int {
          XCTAssertEqual(order, 0, "order not valid!")
        }
        if let playButtonTintColor = controlbar[0]["playTintColor"] as? String {
          XCTAssertEqual(playButtonTintColor, "#ffffff", "play button tint color not valid!")
        }
        if let playImage = controlbar[0]["playImage"] as? String {
          XCTAssertEqual(playImage, "MLPlayButton", "play image not valid!")
        }
        if let pauseImage = controlbar[0]["pauseImage"] as? String {
          XCTAssertEqual(pauseImage, "MLPauseButton", "pause image not valid!")
        }
        if let pauseTintColor = controlbar[0]["pauseTintColor"] as? String {
          XCTAssertEqual(pauseTintColor, "#ffffff", "pause tint color not valid!")
        }
        if let type = controlbar[0]["type"] as? String {
          XCTAssertEqual(type, "button", "type not valid!")
        }
        if let subType = controlbar[0]["subType"] as? String {
          XCTAssertEqual(subType, "play", "subType not valid!")
        }
      }
    }
  }

  func testTimeLabel() {
    let fileURL = NSBundle(forClass: SkinTests.self).URLForResource("Skin", withExtension:"json")!
    let skin = SkinParser.parseConfigFromURL(fileURL)
    if let skinDictionary = skin?.skinDictionary as [String: AnyObject]? {
      if let controlbar = skinDictionary["controlbar"] as? [[String: AnyObject]] {
        if let order = controlbar[1]["order"] as? Int {
          XCTAssertEqual(order, 1, "order not valid!")
        }
        if let textFont = controlbar[1]["textFont"] as? String {
          XCTAssertEqual(textFont, "HelveticaNeue", "textfont not valid!")
        }
        if let textFontSize = controlbar[1]["textFontSize"] as? Int {
          XCTAssertEqual(textFontSize, 15, "textFontSize not valid!")
        }
        if let textColor = controlbar[1]["textColor"] as? String {
          XCTAssertEqual(textColor, "#ffffff", "textColor not valid!")
        }
        if let type = controlbar[1]["type"] as? String {
          XCTAssertEqual(type, "label", "type not valid!")
        }
        if let subType = controlbar[1]["subType"] as? String {
          XCTAssertEqual(subType, "time", "subType not valid!")
        }
      }
    }
  }

  func testSeperator(){
    let fileURL = NSBundle(forClass: SkinTests.self).URLForResource("Skin", withExtension:"json")!
    let skin = SkinParser.parseConfigFromURL(fileURL)
    if let skinDictionary = skin?.skinDictionary as [String: AnyObject]? {
      if let controlbar = skinDictionary["controlbar"] as? [[String: AnyObject]] {
        if let order = controlbar[2]["order"] as? Int {
          XCTAssertEqual(order, 2, "order not valid!")
        }
        if let type = controlbar[2]["type"] as? String {
          XCTAssertEqual(type, "view", "type not valid!")
        }
        if let subType = controlbar[2]["subType"] as? String {
          XCTAssertEqual(subType, "seperator", "subType not valid!")
        }
      }
    }
  }

  func testTimeSlider(){
    let fileURL = NSBundle(forClass: SkinTests.self).URLForResource("Skin", withExtension:"json")!
    let skin = SkinParser.parseConfigFromURL(fileURL)
    if let skinDictionary = skin?.skinDictionary as [String: AnyObject]? {
      if let controlbar = skinDictionary["controlbar"] as? [[String: AnyObject]] {
        if let order = controlbar[3]["order"] as? Int {
          XCTAssertEqual(order, 3, "order not valid!")
        }
        if let type = controlbar[3]["type"] as? String {
          XCTAssertEqual(type, "view", "type not valid!")
        }
        if let subType = controlbar[3]["subType"] as? String {
          XCTAssertEqual(subType, "timeSlider", "subType not valid!")
        }
        if let radius = controlbar[3]["radius"] as? Int {
          XCTAssertEqual(radius, 5, "subType not valid!")
        }
        if let railHeight = controlbar[3]["railHeight"] as? Int {
          XCTAssertEqual(railHeight, 10, "railHeight not valid!")
        }
        if let thumbRadius = controlbar[3]["thumbRadius"] as? Float {
          XCTAssertEqual(thumbRadius, 12.5, "thumbRadius not valid!")
        }
        if let thumbHeight = controlbar[3]["thumbHeight"] as? Int {
          XCTAssertEqual(thumbHeight, 25, "thumbHeight not valid!")
        }
        if let thumbWidth = controlbar[3]["thumbWidth"] as? Int {
          XCTAssertEqual(thumbWidth, 25, "thumbWidth not valid!")
        }
        if let thumbBorder = controlbar[3]["thumbBorder"] as? Int {
          XCTAssertEqual(thumbBorder, 0, "thumbBorder not valid!")
        }
        if let railTintColor = controlbar[3]["railTintColor"] as? String {
          XCTAssertEqual(railTintColor, "#cccccc", "railTintColor not valid!")
        }
        if let bufferTintColor = controlbar[3]["bufferTintColor"] as? String {
          XCTAssertEqual(bufferTintColor, "#9e9b9a", "bufferTintColor not valid!")
        }
        if let progressTintColor = controlbar[3]["progressTintColor"] as? String {
          XCTAssertEqual(progressTintColor, "#ae3f1c", "progressTintColor not valid!")
        }
        if let thumbTintColor = controlbar[3]["thumbTintColor"] as? String {
          XCTAssertEqual(thumbTintColor, "#e54918", "thumbTintColor not valid!")
        }
      }
    }
  }

  func testSeperatorTwo(){
    let fileURL = NSBundle(forClass: SkinTests.self).URLForResource("Skin", withExtension:"json")!
    let skin = SkinParser.parseConfigFromURL(fileURL)
    if let skinDictionary = skin?.skinDictionary as [String: AnyObject]? {
      if let controlbar = skinDictionary["controlbar"] as? [[String: AnyObject]] {
        if let order = controlbar[4]["order"] as? Int {
          XCTAssertEqual(order, 4, "order not valid!")
        }
        if let type = controlbar[4]["type"] as? String {
          XCTAssertEqual(type, "view", "type not valid!")
        }
        if let subType = controlbar[4]["subType"] as? String {
          XCTAssertEqual(subType, "seperator", "subType not valid!")
        }
      }
    }
  }

  func testRemainingLabel(){
    let fileURL = NSBundle(forClass: SkinTests.self).URLForResource("Skin", withExtension:"json")!
    let skin = SkinParser.parseConfigFromURL(fileURL)
    if let skinDictionary = skin?.skinDictionary as [String: AnyObject]? {
      if let controlbar = skinDictionary["controlbar"] as? [[String: AnyObject]] {
        if let order = controlbar[5]["order"] as? Int {
          XCTAssertEqual(order, 5, "order not valid!")
        }
        if let type = controlbar[5]["type"] as? String {
          XCTAssertEqual(type, "label", "type not valid!")
        }
        if let subType = controlbar[5]["subType"] as? String {
          XCTAssertEqual(subType, "remaining", "subType not valid!")
        }
        if let textFont = controlbar[5]["textFont"] as? String {
          XCTAssertEqual(textFont, "HelveticaNeue", "textFont not valid!")
        }
        if let textFontSize = controlbar[5]["textFontSize"] as? Int {
          XCTAssertEqual(textFontSize, 15, "textFontSize not valid!")
        }
        if let textColor = controlbar[5]["textColor"] as? String {
          XCTAssertEqual(textColor, "#ffffff", "textColor not valid!")
        }
      }
    }
  }

  func testDurationLabel(){
    let fileURL = NSBundle(forClass: SkinTests.self).URLForResource("Skin", withExtension:"json")!
    let skin = SkinParser.parseConfigFromURL(fileURL)
    if let skinDictionary = skin?.skinDictionary as [String: AnyObject]? {
      if let controlbar = skinDictionary["controlbar"] as? [[String: AnyObject]] {
        if let order = controlbar[6]["order"] as? Int {
          XCTAssertEqual(order, 6, "order not valid!")
        }
        if let type = controlbar[6]["type"] as? String {
          XCTAssertEqual(type, "label", "type not valid!")
        }
        if let subType = controlbar[6]["subType"] as? String {
          XCTAssertEqual(subType, "duration", "subType not valid!")
        }
        if let textFont = controlbar[6]["textFont"] as? String {
          XCTAssertEqual(textFont, "HelveticaNeue", "textFont not valid!")
        }
        if let textFontSize = controlbar[6]["textFontSize"] as? Int {
          XCTAssertEqual(textFontSize, 15, "textFontSize not valid!")
        }
        if let textColor = controlbar[6]["textColor"] as? String {
          XCTAssertEqual(textColor, "#ffffff", "textColor not valid!")
        }
      }
    }
  }

  func testVolumeView(){
    let fileURL = NSBundle(forClass: SkinTests.self).URLForResource("Skin", withExtension:"json")!
    let skin = SkinParser.parseConfigFromURL(fileURL)
    if let skinDictionary = skin?.skinDictionary as [String: AnyObject]? {
      if let controlbar = skinDictionary["controlbar"] as? [[String: AnyObject]] {
        if let order = controlbar[7]["order"] as? Int {
          XCTAssertEqual(order, 7, "order not valid!")
        }
        if let type = controlbar[7]["type"] as? String {
          XCTAssertEqual(type, "button", "type not valid!")
        }
        if let subType = controlbar[7]["subType"] as? String {
          XCTAssertEqual(subType, "volume", "subType not valid!")
        }
        if let railTintColor = controlbar[7]["railTintColor"] as? String {
          XCTAssertEqual(railTintColor, "#cccccc", "railTintColor not valid!")
        }
        if let progressTintColor = controlbar[7]["progressTintColor"] as? String {
          XCTAssertEqual(progressTintColor, "#0000ff", "progressTintColor not valid!")
        }
        if let thumbTintColor = controlbar[7]["thumbTintColor"] as? String {
          XCTAssertEqual(thumbTintColor, "#c5c5c5", "thumbTintColor not valid!")
        }
        if let image = controlbar[7]["image"] as? String {
          XCTAssertEqual(image, "MLVolumeButton", "image not valid!")
        }
        if let backgroundColor = controlbar[7]["backgroundColor"] as? String {
          XCTAssertEqual(backgroundColor, "#ffffff", "backgroundColor not valid!")
        }
      }
    }
  }

  // header tests

  func testCloseButton(){
    let fileURL = NSBundle(forClass: SkinTests.self).URLForResource("Skin", withExtension:"json")!
    let skin = SkinParser.parseConfigFromURL(fileURL)
    if let skinDictionary = skin?.skinDictionary as [String: AnyObject]? {
      if let controlbar = skinDictionary["header"] as? [[String: AnyObject]] {
        if let order = controlbar[0]["order"] as? Int {
          XCTAssertEqual(order, 0, "order not valid!")
        }
        if let image = controlbar[0]["image"] as? String {
          XCTAssertEqual(image, "MLCloseButton", "image not valid!")
        }
        if let type = controlbar[0]["type"] as? String {
          XCTAssertEqual(type, "button", "type not valid!")
        }
        if let subType = controlbar[0]["subType"] as? String {
          XCTAssertEqual(subType, "close", "subType not valid!")
        }
        if let tintColor = controlbar[0]["tintColor"] as? String {
          XCTAssertEqual(tintColor, "#ffffff", "tintColor not valid!")
        }
      }
    }
  }

  func testTitleLabel(){
    let fileURL = NSBundle(forClass: SkinTests.self).URLForResource("Skin", withExtension:"json")!
    let skin = SkinParser.parseConfigFromURL(fileURL)
    if let skinDictionary = skin?.skinDictionary as [String: AnyObject]? {
      if let controlbar = skinDictionary["header"] as? [[String: AnyObject]] {
        if let order = controlbar[1]["order"] as? Int {
          XCTAssertEqual(order, 1, "order not valid!")
        }
        if let textFont = controlbar[1]["textFont"] as? String {
          XCTAssertEqual(textFont, "HelveticaNeue", "textFont not valid!")
        }
        if let textSize = controlbar[1]["textSize"] as? Int {
          XCTAssertEqual(textSize, 16, "textSize not valid!")
        }
        if let type = controlbar[1]["type"] as? String {
          XCTAssertEqual(type, "label", "type not valid!")
        }
        if let subType = controlbar[1]["subType"] as? String {
          XCTAssertEqual(subType, "title", "subType not valid!")
        }
        if let tintColor = controlbar[1]["tintColor"] as? String {
          XCTAssertEqual(tintColor, "#ffffff", "tintColor not valid!")
        }
      }
    }
  }

  func testShareButton(){
    let fileURL = NSBundle(forClass: SkinTests.self).URLForResource("Skin", withExtension:"json")!
    let skin = SkinParser.parseConfigFromURL(fileURL)
    if let skinDictionary = skin?.skinDictionary as [String: AnyObject]? {
      if let controlbar = skinDictionary["header"] as? [[String: AnyObject]] {
        if let order = controlbar[2]["order"] as? Int {
          XCTAssertEqual(order, 2, "order not valid!")
        }
        if let image = controlbar[2]["image"] as? String {
          XCTAssertEqual(image, "MLShareButton", "image not valid!")
        }
        if let type = controlbar[2]["type"] as? String {
          XCTAssertEqual(type, "button", "type not valid!")
        }
        if let subType = controlbar[2]["subType"] as? String {
          XCTAssertEqual(subType, "share", "subType not valid!")
        }
        if let tintColor = controlbar[2]["tintColor"] as? String {
          XCTAssertEqual(tintColor, "#ffffff", "tintColor not valid!")
        }
      }
    }
  }

}
