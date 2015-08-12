//
//  URLHelper.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 8/6/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

class URLHelper: MobilePlayerViewController {

  enum URLType { case Remote, Local }
  static func checkURL(url: NSURL, urlType type: URLType, completion: (( check: Bool, error: NSError?) -> Void)) {
    var state: MobilePlayerViewController.State
    switch type {
    case .Local:
      if let urlCheck = url as NSURL? {
        completion(check: true, error: nil)
      }else{
        completion(check: false, error: nil)
      }
    case .Remote:
      NSURL.validateUrl(url.absoluteString, completion: { (success, urlString, error) -> Void in
        if success {
          completion(check: true, error: nil)
        }else{
          completion(check: false, error: nil)
        }
      })
    default:
      break
    }
  }
}

extension NSURL {
  struct ValidationQueue {
    static var queue = NSOperationQueue()
  }
  class func
    validateUrl(urlString: String?, completion:(success: Bool, urlString: String?, error: NSString) -> Void) {
      var formattedUrlString: String?
      if (urlString == nil || urlString == "") {
        completion(success: false, urlString: nil, error: "Url String was empty")
        return
      }
      let prefixes = ["http://www.", "https://www.", "www."]
      for prefix in prefixes {
        if ((prefix.rangeOfString(urlString!, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil)) != nil) {
          completion(success: false, urlString: nil, error: "Url String was prefix only")
          return
        }
      }
      let range = urlString!.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet())
      if let test = range {
        completion(success: false, urlString: nil, error: "Url String cannot contain whitespaces")
        return
      }
      formattedUrlString = urlString
      if (!formattedUrlString!.hasPrefix("http://") && !formattedUrlString!.hasPrefix("https://")) {
        formattedUrlString = "http://"+urlString!
      }
      if let validatedUrl = NSURL(string: formattedUrlString!) {
        var request = NSMutableURLRequest(URL: validatedUrl)
        request.HTTPMethod = "HEAD"
        ValidationQueue.queue.cancelAllOperations()
        NSURLConnection.sendAsynchronousRequest(request, queue: ValidationQueue.queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
          let url = request.URL!.absoluteString
          if (error != nil){
            completion(success: false, urlString: url, error: "The url: \(url) received no response")
            return
          }
          if let urlResponse = response as? NSHTTPURLResponse {
            if ((urlResponse.statusCode >= 200 && urlResponse.statusCode < 400) || urlResponse.statusCode == 405) {
              completion(success: true, urlString: url, error: "The url: \(url) is valid!")
              return
            }else{
              completion(success: false, urlString: url, error: "The url: \(url) received a \(urlResponse.statusCode) response")
              return
            }
          }
        })
      }
  }
}