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

  func testPlayerStates() {
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
    if player.getStateAtHistoryIndex(0) == nil &&
      player.getStateAtHistoryIndex(1) == nil &&
      player.getStateAtHistoryIndex(2) == nil {
      XCTFail("Unable to play video")
    }
    let stateCount = player.getStateAtHistoryCount()
    var stateArray = [PlayerState]()
    for i in 0...stateCount {
      if let state = player.getStateAtHistoryIndex(i) as PlayerState? {
        stateArray.append(state)
      }
    }
    var checkValue = contains(stateArray, PlayerState.Buffering)
    if !checkValue {
      XCTFail("Player buffering state not found")
    }
    checkValue = contains(stateArray, PlayerState.Loading)
    if !checkValue {
      XCTFail("Player loading state not found")
    }
    checkValue = contains(stateArray, PlayerState.Paused)
    if !checkValue {
      XCTFail("Player paused state not found")
    }
    checkValue = contains(stateArray, PlayerState.Playing)
    if !checkValue {
      XCTFail("Player playing state not found")
    }
    checkValue = contains(stateArray, PlayerState.Error)
    if checkValue {
      XCTFail("Player error found")
    }
  }
}
