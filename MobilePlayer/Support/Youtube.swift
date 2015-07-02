//
//  Youtube.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 09/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

public extension NSURL {

  func dictionaryForQueryString() -> [String: AnyObject]? {
    return self.query?.dictionaryFromQueryStringComponents()
  }
}

public extension NSString {

  func stringByDecodingURLFormat() -> String {
    var result = self.stringByReplacingOccurrencesOfString("+", withString:" ")
    return result.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
  }

  func dictionaryFromQueryStringComponents() -> [String: AnyObject] {
    var parameters = [String: AnyObject]()
    for keyValue in componentsSeparatedByString("&") {
      let keyValueArray = keyValue.componentsSeparatedByString("=")
      if keyValueArray.count < 2 {
        continue
      }
      let key = keyValueArray[0].stringByDecodingURLFormat()
      let value = keyValueArray[1].stringByDecodingURLFormat()
      parameters[key] = value
    }
    return parameters
  }
}

public class Youtube: NSObject {
  static let infoURL = "http://www.youtube.com/get_video_info?video_id="
  static var userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2)"
    + " AppleWebKit/537.4 (KHTML, like Gecko)"
    + " Chrome/22.0.1229.79 Safari/537.4"

  public static func youtubeIDFromYoutubeURL(youtubeURL: NSURL) -> String? {
    if let
      youtubeHost = youtubeURL.host,
      youtubePathComponents = youtubeURL.pathComponents as? [String] {
        let youtubeAbsoluteString = youtubeURL.absoluteString
        if youtubeHost == "youtu.be" {
          return youtubePathComponents[1]
        } else if youtubeAbsoluteString?.rangeOfString("www.youtube.com/embed") != nil {
          return youtubePathComponents[2]
        } else if youtubeHost == "youtube.googleapis.com" ||
          youtubeURL.pathComponents!.first!.isEqualToString("www.youtube.com") {
            return youtubePathComponents[2]
        } else if let
          queryString = youtubeURL.dictionaryForQueryString(),
          searchParam = queryString["v"] as? String {
            return searchParam
        }
    }
    return nil
  }

  public static func h264videosWithYoutubeID(youtubeID: String) -> [String: AnyObject]? {
    if count(youtubeID) > 0 {
      let urlString = String(format: "%@%@", infoURL, youtubeID) as String
      let url = NSURL(string: urlString)!
      let request = NSMutableURLRequest(URL: url)
      request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
      request.HTTPMethod = "GET"
      var response: NSURLResponse?
      var error: NSError?
      if let
        responseData = NSURLConnection.sendSynchronousRequest(
          request,
          returningResponse: &response,
          error: &error),
        responseString = NSString(
          data: responseData,
          encoding: NSUTF8StringEncoding
        ) {
          let parts = responseString.dictionaryFromQueryStringComponents()
          if parts.count > 0 {
            var videoTitle: String = ""
            var streamImage: String = ""
            if let title = parts["title"] as? String {
              videoTitle = title
            }
            if let image = parts["iurl"] as? String {
              streamImage = image
            }
            if let fmtStreamMap = parts["url_encoded_fmt_stream_map"] as? String {
              // Live Stream
              if let isLivePlayback: AnyObject = parts["live_playback"]{
                if let hlsvp = parts["hlsvp"] as? String {
                  return [
                    "url": "\(hlsvp)",
                    "title": "\(videoTitle)",
                    "image": "\(streamImage)",
                    "isStream": true
                  ]
                }
              } else {
                var videoDictionary = []
                let fmtStreamMapArray = fmtStreamMap.componentsSeparatedByString(",")
                for videoEncodedString in fmtStreamMapArray {
                  var videoComponents = videoEncodedString.dictionaryFromQueryStringComponents()
                  videoComponents["title"] = videoTitle
                  videoComponents["isStream"] = false
                  return videoComponents as [String: AnyObject]
                }
              }
            }
          }
      }
    }
    return nil
  }

  public static func h264videosWithYoutubeURL(
    youtubeURL: NSURL,
    completion: ((
    videoInfo: [String: AnyObject]?,
    error: NSError?) -> Void)?
    ) {
      let youtubeID = youtubeIDFromYoutubeURL(youtubeURL)
      if let
        youtubeID = youtubeIDFromYoutubeURL(youtubeURL),
        videoInformation = h264videosWithYoutubeID(youtubeID) {
          completion?(videoInfo: videoInformation, error: nil)
      } else {
        completion?(
          videoInfo: nil,
          error: NSError(
            domain: "com.mobileplayer.yt.backgroundqueue",
            code: 1001,
            userInfo: ["error": "Invalid YouTube URL"]))
      }
  }
}
