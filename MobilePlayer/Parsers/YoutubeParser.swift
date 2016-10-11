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

  private static func decodeURLEncodedString(urlString: String) -> String {
    let withSpaces = urlString.replacingOccurrences(of: "+", with: " ")
    return withSpaces.removingPercentEncoding ?? withSpaces
  }

  private static func queryStringToDictionary(queryString: String) -> [String: Any] {
    var parameters = [String: Any]()
    for keyValuePair in queryString.components(separatedBy: "&") {
      let keyValueArray = keyValuePair.components(separatedBy: "=")
      if keyValueArray.count < 2 {
        continue
      }
      let key = decodeURLEncodedString(urlString: keyValueArray[0])
      let value = decodeURLEncodedString(urlString: keyValueArray[1])
      parameters[key] = value
    }
    return parameters
  }

  static func youtubeIDFromURL(url: URL) -> String? {
    guard let host = url.host else { return nil }

    if host.range(of: "youtu.be") != nil {
      return url.pathComponents[1]
    } else if (host.range(of: "youtube.com") != nil && url.pathComponents[1] == "embed") || (host == "youtube.googleapis.com") {
      return url.pathComponents[2]
    } else if
      host.range(of: "youtube.com") != nil,
      let queryString = url.query,
      let videoParam = queryStringToDictionary(queryString: queryString)["v"] as? String {
        return videoParam
    }

    return nil
  }

  static func h264videosWithYoutubeID(_ youtubeID: String,
                                      completion: @escaping (_ videoInfo: YoutubeVideoInfo?, _ error: NSError?) -> Void) {
    var request = URLRequest(url: URL(string: "\(infoURL)\(youtubeID)")!)
    request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
    request.httpMethod = "GET"
    NSURLConnection.sendAsynchronousRequest(
      request,
      queue: .main,
      completionHandler: { response, data, error in
        if let error = error {
          completion(nil, error as NSError?)
          return
        }
        guard let
          data = data,
          let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String else {
            completion(
              nil,
              NSError(domain: "com.movielala.MobilePlayer.error", code: 0, userInfo: nil))
            return
        }
        let parts = self.queryStringToDictionary(queryString: dataString)
        let title = parts["title"] as? String
        let previewImageURL = parts["iurl"] as? String
        if parts["live_playback"] != nil {
          completion(
            YoutubeVideoInfo(
              title: title,
              previewImageURL: previewImageURL,
              videoURL: parts["hlsvp"] as? String,
              isStream: true),
            nil)
        } else if let fmtStreamMap = parts["url_encoded_fmt_stream_map"] as? String {
          let videoComponents = self.queryStringToDictionary(queryString: fmtStreamMap.components(separatedBy: ",")[0])
          completion(
            YoutubeVideoInfo(
              title: title,
              previewImageURL: previewImageURL,
              videoURL: videoComponents["url"] as? String,
              isStream: false),
            nil)
        }
    })
  }
}
