//
//  PlayerStateTest.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 8/5/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import XCTest
import KIF
import MobilePlayer

class PlayerStateTest: KIFTestCase {
  let screenSize: CGRect = UIScreen.mainScreen().bounds
  var tester: KIFUITestActor {
    get {
      return KIFUITestActor(inFile: __FILE__, atLine: __LINE__, delegate: self)
    }
  }
  let fileURL = NSBundle(forClass: PlayerStateTest.self).URLForResource(
    "Skin", withExtension:"json")!

  override func setUp() {
    super.setUp()
  }

  override func beforeEach() { }

  override func afterEach() { }

  func testPlayPauseStateTest() {
    let testURL = NSURL(string: "https://www.youtube.com/watch?v=ZyIVaZXDhho")!
    let expectation: XCTestExpectation = expectationWithDescription("PlayAndPauseTap")
    // Setup test video
    let player = MobilePlayerViewController(
      youTubeURL: testURL,
      configFileURL: fileURL
    )
    expectation.fulfill()
    waitForExpectationsWithTimeout(10, handler: nil)
    tester.waitForTimeInterval(2)
    tester.tapScreenAtPoint(CGPointMake(10.0, screenSize.height - 20))
    tester.waitForTimeInterval(2)
    tester.tapScreenAtPoint(CGPointMake(10.0, screenSize.height - 20))
    tester.waitForTimeInterval(5)

    /*
    if let state = player.getStateAtHistory(0)?.hashValue {
      debugPrintln(state)
      if state != 4 {
        XCTFail("Play and pause state not working!")
      }else{
        debugPrintln("test ok")
      }
    }
    */
  }
}
