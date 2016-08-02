//
//  YoutubeParser.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 09/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

struct YoutubeVideoInfo {
  let title: String?
  let previewImageURL: String?
  let videoURL: String?
  let isStream: Bool?
}

class YoutubeParser: NSObject {
  static let infoURL = "https://www.youtube.com/get_video_info?video_id="
  static let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2)"
    + " AppleWebKit/537.4 (KHTML, like Gecko)"
    + " Chrome/22.0.1229.79 Safari/537.4"

  private static func decodeURLEncodedString(_ urlString: String) -> String {
    let withSpaces = urlString.replacingOccurrences(of: "+", with:" ")
    return withSpaces.removingPercentEncoding ?? withSpaces
  }

  private static func queryStringToDictionary(_ queryString: String) -> [String: AnyObject] {
    var parameters = [String: AnyObject]()
    for keyValuePair in queryString.components(separatedBy: "&") {
      let keyValueArray = keyValuePair.components(separatedBy: "=")
      if keyValueArray.count < 2 {
        continue
      }
      let key = decodeURLEncodedString(keyValueArray[0])
      let value = decodeURLEncodedString(keyValueArray[1])
      parameters[key] = value
    }
    return parameters
  }

  static func youtubeIDFromURL(_ url: URL) -> String? {
    if let
      host = url.host,
      pathComponents = url.pathComponents {
        if host.range(of: "youtu.be") != nil {
          return pathComponents[1]
        } else if (host.range(of: "youtube.com") != nil && pathComponents[1] == "embed") || (host == "youtube.googleapis.com") {
          return pathComponents[2]
        } else if let
          queryString = url.query,
          videoParam = queryStringToDictionary(queryString)["v"] as? String
          where (host.range(of: "youtube.com") != nil) {
            return videoParam
        }
    }
    return nil
  }

  static func h264videosWithYoutubeID(
    _ youtubeID: String,
    completion: (videoInfo: YoutubeVideoInfo?, error: NSError?) -> Void) {
      let request = NSMutableURLRequest(url: URL(string: "\(infoURL)\(youtubeID)")!)
      request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
      request.httpMethod = "GET"
      NSURLConnection.sendAsynchronousRequest(
        request as URLRequest,
        queue: OperationQueue.main,
        completionHandler: { response, data, error in
          if let error = error {
            completion(videoInfo: nil, error: error)
            return
          }
          guard let
            data = data,
            dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String else {
              completion(
                videoInfo: nil,
                error: NSError(domain: "com.movielala.MobilePlayer.error", code: 0, userInfo: nil))
              return
          }
          let parts = self.queryStringToDictionary(dataString)
          let title = parts["title"] as? String
          let previewImageURL = parts["iurl"] as? String
          if parts["live_playback"] != nil {
            completion(
              videoInfo: YoutubeVideoInfo(
                title: title,
                previewImageURL: previewImageURL,
                videoURL: parts["hlsvp"] as? String,
                isStream: true),
              error: nil)
          } else if let fmtStreamMap = parts["url_encoded_fmt_stream_map"] as? String {
            let videoComponents = self.queryStringToDictionary(fmtStreamMap.components(separatedBy: ",")[0])
            completion(
              videoInfo: YoutubeVideoInfo(
                title: title,
                previewImageURL: previewImageURL,
                videoURL: videoComponents["url"] as? String,
                isStream: false),
              error: nil)
          }
      })
  }
}
