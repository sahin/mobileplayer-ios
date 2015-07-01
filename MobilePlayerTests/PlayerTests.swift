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
import KIF

class PlayerTests: KIFTestCase {
  let screenSize: CGRect = UIScreen.mainScreen().bounds
  var tester: KIFUITestActor {
    get {
      return KIFUITestActor(inFile: __FILE__, atLine: __LINE__, delegate: self)
    }
  }
  let fileURL = NSBundle(
    forClass: SkinParserTests.self
    ).URLForResource(
      "TestSkin", withExtension:"json"
    )!

  override func beforeEach() { }

  override func afterEach() { }

  func testPlayerStatesWithPreroll() {
    let testURL = NSURL(string: "https://www.youtube.com/watch?v=Kznek1uNVsg")!
    let expectation: XCTestExpectation = expectationWithDescription("")
    // Setup test video
    let player = MobilePlayerViewController(
      youTubeURL: testURL,
      configFileURL: fileURL
    )
    player.config.prerollViewController = PreRollViewController()
    expectation.fulfill()
    waitForExpectationsWithTimeout(2, handler: nil)
    if player.config.prerollViewController != nil {
      tester.waitForTimeInterval(2)
      tester.tapScreenAtPoint(CGPointMake(10.0, screenSize.height - 20))
      tester.waitForTimeInterval(5)
    }
    // check player state changed
    if playerStateHistory.count < 2 {
      XCTFail("Unable to play video")
    }
    playerStateCheck()
  }

  func playerStateCheck() {
    // Buffering Test
    if contains(playerStateHistory, PlayerState.Buffering) {
      // Paused Test
      if contains(playerStateHistory, PlayerState.Paused) {
        // Playing Test
        if contains(playerStateHistory, PlayerState.Playing) {
          // Idle Test
          if contains(playerStateHistory, PlayerState.Idle) {
            // Loading Test
            if contains(playerStateHistory, PlayerState.Loading) {
            } else {
              XCTFail("Player loading state not found")
            }
          } else {
            XCTFail("Player idle state not found")
          }
        } else {
          XCTFail("Player playing state not found")
        }
      } else {
        XCTFail("Player paused state not found")
      }
    } else {
      XCTFail("Player buffering state not found")
    }
  }
}
