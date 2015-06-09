//
//  YoutubeTests.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 09/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import XCTest
import MovielalaPlayer

class YoutubeTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  func testStringByDecodingURLFormat() {
    let youtube = Youtube()
    let originalString = "https://www.youtube.com/watch?v=XUFpdwbfqqQ+XUFpdwbfqqQ"
    let testString = "https://www.youtube.com/watch?v=XUFpdwbfqqQ XUFpdwbfqqQ"
    let comparsionString:String = youtube.stringByDecodingURLFormat(originalString)
    XCTAssertEqual(comparsionString, testString, "String decoding failed")
  }
  
  func testDictionaryFromQueryStringComponents() {
    let youtube = Youtube()
    let sampleLink = "https://www.youtube.com/watch?v=o0jJiB2Ygpg&list=RDo0jJiB2Ygpg"
    let dictionary:NSDictionary? = youtube.dictionaryFromQueryStringComponents(sampleLink)
    XCTAssertNotNil(dictionary, "url dictionary parse error")
  }
  
}
