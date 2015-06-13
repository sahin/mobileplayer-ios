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
    XCTAssertNotNil(comparsionString, "comparsionString is nil")
    XCTAssertEqual(comparsionString, testString, "String decoding failed")
  }

  func testDictionaryFromQueryStringComponents() {
    let sampleLink = "https://www.youtube.com/watch?v=o0jJiB2Ygpg&list=RDo0jJiB2Ygpg"
    let dictionary = sampleLink.dictionaryFromQueryStringComponents() as [String:AnyObject]
    XCTAssertNotNil(dictionary["list"], "url dictionary parse error")
    if let list = dictionary["list"] as? String {
      XCTAssertEqual(list, "RDo0jJiB2Ygpg", "list not equal value")
    }
    if let link = dictionary["https://www.youtube.com/watch?v="] as? String {
      XCTAssertEqual(link, "o0jJiB2Ygpg", "link not equal value")
    }
  }

  func testYoutubeIDFromYoutubeURL() {
    let youTube = Youtube()
    let sampleLink = NSURL(string: "http://www.youtube.com/watch?v=1hZ98an9wjo")!
    XCTAssertNotNil(youTube.youtubeIDFromYoutubeURL(sampleLink), "Youtube ID is nil")
    if let youtubeID = youTube.youtubeIDFromYoutubeURL(sampleLink) {
      XCTAssertEqual(youtubeID, "1hZ98an9wjo", "Youtube ID not same")
    }
  }

  func testH264videosWithYoutubeURL() {
    let youTube = Youtube()
    let sampleLink = NSURL(string: "http://www.youtube.com/watch?v=1hZ98an9wjo")!
    if let videoComponents = youTube.h264videosWithYoutubeID("1hZ98an9wjo") {
      XCTAssertNotNil(videoComponents, "video component is nil")
      if let itag = videoComponents["itag"] as? String {
        XCTAssertEqual(itag, "22", "itag not equal")
      }
      if let quality = videoComponents["quality"] as? String {
        XCTAssertEqual(quality, "hd720", "quality not equal")
      }
      if let fallback_host = videoComponents["fallback_host"] as? String {
        XCTAssertEqual(fallback_host, "tc.v7.cache1.googlevideo.com", "fallback_host not equal")
      }
      if let type = videoComponents["type"] as? String {
        XCTAssertEqual(type, "video/mp4; codecs=\"avc1.64001F, mp4a.40.2\"", "type not equal")
      }
    }
  }

  func testh264videosWithYoutubeURLBlock() {
    let youTube = Youtube()
    if let videoURL = NSURL(string: "http://www.youtube.com/watch?v=1hZ98an9wjo") {
      youTube.h264videosWithYoutubeURL(videoURL, completion: { (videoInfo, error) -> Void in
        XCTAssertNotNil(videoInfo, "video dictionary is nil")
        if let info = videoInfo as [String:AnyObject]? {
          if let itag = info["itag"] as? String {
          XCTAssertEqual(itag, "22", "itag not equal")
          }
          if let quality = info["quality"] as? String {
          XCTAssertEqual(quality, "hd720", "quality not equal")
          }
          if let fallback_host = info["fallback_host"] as? String {
          XCTAssertEqual(fallback_host, "tc.v7.cache1.googlevideo.com", "fallback_host not equal")
          }
          if let type = info["type"] as? String {
          XCTAssertEqual(type, "video/mp4; codecs=\"avc1.64001F, mp4a.40.2\"", "type not equal")
          }

        }
      })
    }
    if let liveVideoURL = NSURL(string: "https://www.youtube.com/watch?v=rxGoGg7n77A"){
      youTube.h264videosWithYoutubeURL(liveVideoURL, completion: { (videoInfo, error) -> Void in
        XCTAssertNotNil(videoInfo, "video dictionary is nil")
        if let info = videoInfo as [String:AnyObject]? {
          XCTAssertNotNil(info["url"], "live stream url is nil")
        }
      })
    }
  }
}
