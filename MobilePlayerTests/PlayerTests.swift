//
//  PlayerTests.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 29/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import XCTest
import MobilePlayer

class PlayerTests: XCTestCase {
  let expectationTimeout: NSTimeInterval = 5.0
  let fileURL = NSBundle(
    forClass: SkinParserTests.self
    ).URLForResource(
      "TestSkin", withExtension:"json"
    )!

  override func setUp() {
    super.setUp()
  }

  func testVideoIsAvailable() {
    var expectation: XCTestExpectation = expectationWithDescription("")
    let videoURL = NSURL(string: "https://www.youtube.com/watch?v=Kznek1uNVsg")!
    let player = MobilePlayerViewController(
      youTubeURL: videoURL,
      configFileURL: fileURL
    )
    XCTAssertNotNil(player.currentVideoURL);
    expectation.fulfill()
    waitForExpectationsWithTimeout(expectationTimeout, handler: nil)
  }

  func testVideoHasMetadata() {
    var expectation: XCTestExpectation = expectationWithDescription("")
    let videoURL = NSURL(string: "https://www.youtube.com/watch?v=nXL1agXVeuo")!
    let player = MobilePlayerViewController(
      youTubeURL: videoURL,
      configFileURL: fileURL
    )
    XCTAssertNotNil(player.currentVideoURL, "video url is nil");
    if let playerTitle = player.title {
      XCTAssertEqual(
        playerTitle,
        "Star Wars: The Fall of the Galactic Republic",
        "Player title not same"
      )
    }
    expectation.fulfill()
    waitForExpectationsWithTimeout(expectationTimeout, handler: nil)
  }
}
