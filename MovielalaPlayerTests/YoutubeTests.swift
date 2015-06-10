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
    let originalString = "https://www.youtube.com/watch?v=XUFpdwbfqqQ+XUFpdwbfqqQ"
    let testString = "https://www.youtube.com/watch?v=XUFpdwbfqqQ XUFpdwbfqqQ"
    let comparsionString:String = originalString.stringByDecodingURLFormat()
    XCTAssertEqual(comparsionString, testString, "String decoding failed")
  }
  
  func testDictionaryFromQueryStringComponents() {
    let sampleLink = "https://www.youtube.com/watch?v=o0jJiB2Ygpg&list=RDo0jJiB2Ygpg"
    let dictionary:NSDictionary? = sampleLink.dictionaryFromQueryStringComponents()
    XCTAssertNotNil(dictionary, "url dictionary parse error")
  }
  
  func testYoutubeIDFromYoutubeURL() {
    let youTube = Youtube()
    let sampleLink:NSURL = NSURL(string: "http://www.youtube.com/watch?v=1hZ98an9wjo")!
    XCTAssertEqual(youTube.youtubeIDFromYoutubeURL(sampleLink), "1hZ98an9wjo", "Youtube ID not matching")
  }
  
  func testH264videosWithYoutubeURL() {
    let youTube = Youtube()
    let sampleLink:NSURL = NSURL(string: "http://www.youtube.com/watch?v=1hZ98an9wjo")!
    var videoComponents = youTube.h264videosWithYoutubeID("1hZ98an9wjo")
    XCTAssertNotNil(videoComponents.objectForKey("fallback_host"), "video component fallback_host is nil")
    XCTAssertNotNil(videoComponents.objectForKey("itag"), "video component itag is nil")
    XCTAssertNotNil(videoComponents.objectForKey("quality"), "video component quality is nil")
    XCTAssertNotNil(videoComponents.objectForKey("type"), "video component type is nil")
    XCTAssertNotNil(videoComponents.objectForKey("url"), "video component url is nil")
  }
  
}
