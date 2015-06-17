//
//  SkinParserTests.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 08/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import XCTest
import MovielalaPlayer

class SkinParserTests: XCTestCase {
  let fileURL = NSBundle(forClass: SkinParserTests.self).
    URLForResource("TestSkin", withExtension:"json")!

  override func setUp() {
    super.setUp()
  }

  func testControlbarConfig() {
    if let config: MovielalaPlayerConfig =
      SkinParser.parseConfigFromURL(fileURL) {
      XCTAssertEqual(
        config.controlbarConfig.timeTextColor,
        UIColor(hexString:"#ffff00"),
        "timeText tint color not equal"
        )
      XCTAssertEqual(
        config.controlbarConfig.timeBackgroundColor,
        UIColor(hexString:"#ff00ff"),
        "timeLabel background color not equal"
        )
      XCTAssertEqual(
        config.controlbarConfig.timeSliderBackgroundColor,
        UIColor(hexString:"#ff00ff"),
        "CustomTime Slider background color not equal"
        )
      XCTAssertEqual(
        config.controlbarConfig.timeSliderThumbTintColor,
        UIColor(hexString:"#ffffff"),
        "CustomTime Slider thumb tint color not equal"
        )
      XCTAssertEqual(
        config.controlbarConfig.timeSliderProgressTintColor,
        UIColor(hexString:"#ff0000"),
        "CustomTime Slider progress tint color not equal"
        )
      XCTAssertEqual(
        config.controlbarConfig.timeSliderBufferTintColor,
        UIColor(hexString:"#555555"),
        "CustomTime Slider buffer tint color not equal"
        )
      XCTAssertEqual(
        config.controlbarConfig.timeSliderRailTintColor,
        UIColor(hexString:"#ffff00"),
        "CustomTime Slider rail tint color not equal"
        )
    }
  }

  func testControlbarButtons() {
    if let config: MovielalaPlayerConfig =
      SkinParser.parseConfigFromURL(fileURL) {
        XCTAssertEqual(
          config.controlbarConfig.playButtonTintColor,
          UIColor(hexString:"#ffff00"),
          "playButton tint color not equal"
        )
        XCTAssertEqual(
          config.controlbarConfig.playButtonBackgroundColor,
          UIColor(hexString:"#ff00ff"),
          "playButton background color not equal"
        )
        XCTAssertEqual(
          config.controlbarConfig.pauseButtonTintColor,
          UIColor(hexString:"#ffff00"),
          "pauseButton tint color not equal"
        )
        XCTAssertEqual(
          config.controlbarConfig.playButtonImage,
          UIImage(
            named: "MLPlayButton",
            inBundle: NSBundle(forClass: MovielalaPlayerViewController.self),
            compatibleWithTraitCollection: nil
            )!,
          "Play Button image not found")
        XCTAssertEqual(
          config.controlbarConfig.pauseButtonImage,
          UIImage(
            named: "MLPauseButton",
            inBundle: NSBundle(forClass: MovielalaPlayerViewController.self),
            compatibleWithTraitCollection: nil
            )!,
          "Pause Button image not found")
    }
  }

  func testShareConfig() {
    if let config: MovielalaPlayerConfig =
      SkinParser.parseConfigFromURL(fileURL) {
      XCTAssertEqual(
        config.shareConfig.tintColor,
        UIColor(hexString:"#ffff00"),
        "Share tint color not equal"
        )
      XCTAssertEqual(
        config.shareConfig.backgroundColor,
        UIColor(hexString:"#ff00ff"),
        "Share background color not equal"
        )
      XCTAssertEqual(
        config.shareConfig.imageName,
        UIImage(
          named: "MLShareButton",
          inBundle: NSBundle(forClass: MovielalaPlayerViewController.self),
          compatibleWithTraitCollection: nil
          )!,
        "Share Button image not found")
    }
  }

  func testTitleConfig() {
    if let config: MovielalaPlayerConfig =
      SkinParser.parseConfigFromURL(fileURL) {
      XCTAssertEqual(
        config.titleConfig.backgroundColor,
        UIColor(hexString:"#ff00ff"),
        "Title background color not equal"
        )
      XCTAssertEqual(
        config.titleConfig.textColor,
        UIColor(hexString:"#ffff00"),
        "Title text color not equal")
    }
  }

  func testCloseButton() {
    if let config: MovielalaPlayerConfig =
      SkinParser.parseConfigFromURL(fileURL) {
      XCTAssertEqual(
        config.closeConfig.tintColor,
        UIColor(hexString:"#ffff00"),
        "Close Button tint color not equal"
        )
      XCTAssertEqual(
        config.closeConfig.backgroundColor,
        UIColor(hexString:"#ff00ff"),
        "Close Button background color not equal"
        )
      XCTAssertEqual(
        config.closeConfig.imageName,
        UIImage(
          named: "MLCloseButton",
          inBundle: NSBundle(forClass: MovielalaPlayerViewController.self),
          compatibleWithTraitCollection: nil
          )!,
        "Close Button image not found")
    }
  }
}
