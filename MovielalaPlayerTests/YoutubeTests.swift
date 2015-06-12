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
    let comparsionString = originalString.stringByDecodingURLFormat()
    XCTAssertEqual(comparsionString, testString, "String decoding failed")
  }
  
  func testDictionaryFromQueryStringComponents() {
    let sampleLink = "https://www.youtube.com/watch?v=o0jJiB2Ygpg&list=RDo0jJiB2Ygpg"
    let dictionary = sampleLink.dictionaryFromQueryStringComponents()
    XCTAssertNotNil(dictionary, "url dictionary parse error")
  }
  
  func testYoutubeIDFromYoutubeURL() {
    let youTube = Youtube()
    let sampleLink = NSURL(string: "http://www.youtube.com/watch?v=1hZ98an9wjo")!
    XCTAssertNotNil(youTube.youtubeIDFromYoutubeURL(sampleLink), "Youtube ID is nil")
  }
  
  func testH264videosWithYoutubeURL() {
    let youTube = Youtube()
    let sampleLink:NSURL = NSURL(string: "http://www.youtube.com/watch?v=1hZ98an9wjo")!
    var videoComponents = youTube.h264videosWithYoutubeID("1hZ98an9wjo")
    XCTAssertNotNil(videoComponents, "video component is nil")
  }

  func testh264videosWithYoutubeURLBlock() {
    let youTube = Youtube()
    
    if let videoURL = NSURL(string: "http://www.youtube.com/watch?v=1hZ98an9wjo") {
      youTube.h264videosWithYoutubeURL(videoURL, completion: { (videoInfo, error) -> Void in
        XCTAssertNotNil(videoInfo, "video dictionary is nil")
      })
    }
    if let liveVideoURL = NSURL(string: "https://www.youtube.com/watch?v=rxGoGg7n77A"){
      youTube.h264videosWithYoutubeURL(liveVideoURL, completion: { (videoInfo, error) -> Void in
        XCTAssertNotNil(videoInfo, "video dictionary is nil")
      })
    }
  }
}
