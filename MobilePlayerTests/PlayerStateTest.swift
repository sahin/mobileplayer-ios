//
//  PlayerStateTest.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 8/5/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MobilePlayer
import KIF

class PlayerStateTest: KIFTestCase {
  var tester: KIFUITestActor {
    get {
      return KIFUITestActor(inFile: __FILE__, atLine: __LINE__, delegate: self)
    }
  }

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  override func beforeEach() { }

  override func afterEach() { }

  func testPlayerStates() {
    loadingStateTest()
  }

  func loadingStateTest() {
    let expectation: XCTestExpectation = expectationWithDescription("LoadingState")
    expectation.fulfill()
    if let player: UILabel = tester.waitForViewWithAccessibilityLabel("PlayerState") as? UILabel {
      tester.waitForTimeInterval(1.5)
      if let str = player.text as String? {
        let items = componentsWithString(str)
        var state = items.first?.toInt()
        var previousState = items.last?.toInt()
        if let previousState = previousState as Int? {
          debugPrintln(previousState)
          println("Loading state : \(previousState)")
          XCTAssertEqual(previousState, 6, "Not changed loading state")
          seekingForwardTest()
        }
      }
    }
  }

  func seekingForwardTest() {
    let expectation: XCTestExpectation = expectationWithDescription("ForwardState")
    expectation.fulfill()
    tester.waitForTimeInterval(0.01)
    tester.tapViewWithAccessibilityLabel("Play") // playing
    tester.swipeViewWithAccessibilityLabel("Thumb", inDirection: KIFSwipeDirection.Right)
    if let player: UILabel = tester.waitForViewWithAccessibilityLabel("PlayerState") as? UILabel {
      if let str = player.text as String? {
        let items = componentsWithString(str)
        var state = items.first?.toInt()
        var previousState = items.last?.toInt()
        if let previousState = previousState as Int? {
          println("Forward state : \(previousState)")
          XCTAssertEqual(previousState, 10, "Not changed forward seeking state")
          seekingBackwardTest()
        }
      }
    }
  }

  func seekingBackwardTest() {
    let expectation: XCTestExpectation = expectationWithDescription("BackwardState")
    expectation.fulfill()
    tester.waitForTimeInterval(1)
    tester.swipeViewWithAccessibilityLabel("Thumb", inDirection: KIFSwipeDirection.Left)
    if let player: UILabel = tester.waitForViewWithAccessibilityLabel("PlayerState") as? UILabel {
      if let str = player.text as String? {
        let items = componentsWithString(str)
        var state = items.first?.toInt()
        var previousState = items.last?.toInt()
        if let previousState = previousState as Int? {
          println("Backward state : \(previousState) - \(state)")
          XCTAssertEqual(previousState, 2, "Not changed backward seeking state")
          playPauseStateTests()
        }
      }
    }
  }

  func playPauseStateTests() {
    let expectation: XCTestExpectation = expectationWithDescription("PlayAndPauseState")
    expectation.fulfill()
    if let player: UILabel = tester.waitForViewWithAccessibilityLabel("PlayerState") as? UILabel {
      tester.tapViewWithAccessibilityLabel("Play") // playing
      tester.waitForTimeInterval(1)
      tester.tapViewWithAccessibilityLabel("Play") // paused
      tester.waitForTimeInterval(1)
      tester.tapViewWithAccessibilityLabel("Play") // playing
      tester.waitForTimeInterval(1)
      tester.tapViewWithAccessibilityLabel("Play") // paused
      tester.waitForTimeInterval(1)
      if let str = player.text as String? {
        let items = componentsWithString(str)
        var state = items.first?.toInt()
        var previousState = items.last?.toInt()
        println("Play-Pause state : \(state)-\(previousState)")
        if let state = state as Int? {
          XCTAssertEqual(state, 4, "Not changed playing state")
        }
        if let previousState = previousState as Int? {
          XCTAssertEqual(previousState, 3, "Not changed paused state")
        }
      }
    }
    waitForExpectationsWithTimeout(10, handler: nil)
  }

  func componentsWithString(str: String) -> [String] {
    return str.componentsSeparatedByString("-") as [String]
  }

}
