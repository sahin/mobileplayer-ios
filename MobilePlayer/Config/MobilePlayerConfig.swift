//
//  MobilePlayerConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public class MobilePlayerConfig {
  public let watermark: WatermarkConfig?
  public let topBarConfig: BarConfig
  public let bottomBarConfig: BarConfig

  public convenience init() {
    self.init(dictionary: [String: AnyObject]())
  }

  public convenience init(fileURL: NSURL) {
    if let
      jsonString = (try? String(contentsOfURL: fileURL, encoding: NSUTF8StringEncoding)),
      jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding),
      dictionary = (try? NSJSONSerialization.JSONObjectWithData(jsonData, options: [])) as? [String: AnyObject] {
        self.init(dictionary: dictionary)
    } else {
      self.init()
    }
  }

  public init(dictionary: [String: AnyObject]) {
    if let watermarkDictionary = dictionary["watermark"] as? [String: AnyObject] {
      watermark = WatermarkConfig(dictionary: watermarkDictionary)
    } else {
      watermark = nil
    }

    if let topBarDictionary = dictionary["topBar"] as? [String: AnyObject] {
      topBarConfig = BarConfig(dictionary: topBarDictionary)
    } else {
      topBarConfig = BarConfig()
    }

    if let bottomBarDictionary = dictionary["bottomBar"] as? [String: AnyObject] {
      bottomBarConfig = BarConfig(dictionary: bottomBarDictionary)
    } else {
      bottomBarConfig = BarConfig()
    }
  }
}
