//
//  Youtube.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 09/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

public class Youtube: NSObject {
  
  let infoURL = "http://www.youtube.com/get_video_info?video_id="
  let thumbnailURL = "http://img.youtube.com/vi/%@/%@.jpg"
  let dataURL = "http://gdata.youtube.com/feeds/api/videos/%@?alt=json"
  let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4"
  
  public func stringByDecodingURLFormat(str:String) -> String {
    var result = str.stringByReplacingOccurrencesOfString("+", withString:" ", options: .LiteralSearch, range: nil)
    return result.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
  }
  
  public func dictionaryFromQueryStringComponents(queryString:String) -> NSMutableDictionary {
    let parameters = NSMutableDictionary()
    let arrResults = NSMutableArray(capacity: 1)
    for keyValue in queryString.componentsSeparatedByString("&") {
      let keyValueArray:NSArray = keyValue.componentsSeparatedByString("=")
      if (keyValueArray.count < 2) {
        continue;
      }
      let key:String = stringByDecodingURLFormat(keyValueArray.objectAtIndex(0) as! String)
      let value:String = stringByDecodingURLFormat(keyValueArray.objectAtIndex(1) as! String)
      parameters.setObject(value, forKey: key)
    }
    return parameters
  }
}

