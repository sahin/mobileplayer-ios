//
//  YoutubeParserTests.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 09/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation
import XCTest
@testable import MobilePlayer

class YoutubeParserTests: XCTestCase {

  func testYoutubeIDFromURL() {
    let youtubeID = "rNkjAGNCpeE"
    XCTAssert(
      youtubeID == YoutubeParser.youtubeIDFromURL(NSURL(string: "https://www.youtube.com/watch?v=\(youtubeID)")!),
      "failed to fetch youtube id from url")
  }

  func testH264videosWithYoutubeID() {
    let fetchExpectation = expectationWithDescription("video information fetching")

    var youtubeVideoInfo: YoutubeVideoInfo?
    YoutubeParser.h264videosWithYoutubeID("1hZ98an9wjo") { videoInfo, error in
      youtubeVideoInfo = videoInfo
      fetchExpectation.fulfill()
    }

    waitForExpectationsWithTimeout(5) { error in
      XCTAssert(youtubeVideoInfo?.title == "10 Unsolved Mysteries Of The Brain", "video title is wrong")
      XCTAssert(youtubeVideoInfo?.isStream == false, "video isStream property is wrong")
      XCTAssert(
        youtubeVideoInfo?.previewImageURL == "https://i.ytimg.com/vi/1hZ98an9wjo/hqdefault.jpg",
        "video preview image url is wrong")
      XCTAssert(
        NSURL(string: youtubeVideoInfo!.videoURL!)?.host?.containsString("googlevideo.com") == true,
        "video url is wrong")
    }
  }

//  func testH264videosWithYoutubeURL() {
//    let sampleLink = NSURL(string: "http://www.youtube.com/watch?v=1hZ98an9wjo")!
//    if let videoComponents = Youtube.h264videosWithYoutubeID("1hZ98an9wjo") {
//      XCTAssertNotNil(videoComponents, "video component is nil")
//      if let itag = videoComponents["itag"] as? String {
//        XCTAssertEqual(itag, "22", "itag not equal")
//      }
//      if let quality = videoComponents["quality"] as? String {
//        XCTAssertEqual(quality, "hd720", "quality not equal")
//      }
//      if let fallback_host = videoComponents["fallback_host"] as? String {
//        XCTAssertEqual(fallback_host, "tc.v7.cache1.googlevideo.com", "fallback_host not equal")
//      }
//      if let type = videoComponents["type"] as? String {
//        XCTAssertEqual(type, "video/mp4; codecs=\"avc1.64001F, mp4a.40.2\"", "type not equal")
//      }
//    }
//  }
}
