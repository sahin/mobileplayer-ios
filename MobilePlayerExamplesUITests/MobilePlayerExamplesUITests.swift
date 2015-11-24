//
//  MobilePlayerExamplesUITests.swift
//  MobilePlayerExamplesUITests
//
//  Created by Baris Sencan on 23/11/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import XCTest

class MobilePlayerExamplesUITests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    continueAfterFailure = false
    XCUIApplication().launch()
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testExample() {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
}
