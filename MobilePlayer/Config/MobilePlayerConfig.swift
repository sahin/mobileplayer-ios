//
//  MobilePlayerConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

/// Holds player configuration values.
public class MobilePlayerConfig {

  /// Watermark configuration.
  public let watermarkConfig: WatermarkConfig?

  /// Top controls bar configuration.
  public let topBarConfig: BarConfig

  /// Bottom controls bar configuration.
  public let bottomBarConfig: BarConfig

  /// Initializes with default values.
  public convenience init() {
    self.init(dictionary: [String: AnyObject]())
  }

  /// Initializes using a configuration JSON file.
  ///
  /// - parameters:
  ///   - fileURL: URL indicating the location of the configuration file.
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

  /// Initializes using a dictionary.
  ///
  /// * Key for `watermarkConfig` is `"watermark"` and its value should be a watermark configuration dictionary.
  /// * Key for `topBarConfig` is `"topBar"` and its value should be a bar configuration dictionary.
  /// * Key for `bottomBarConfig` is `"bottomBar"` and its value should be a bar configuration dictionary.
  ///
  /// - parameters:
  ///   - dictionary: Configuration dictionary.
  public init(dictionary: [String: AnyObject]) {
    if let watermarkDictionary = dictionary["watermark"] as? [String: AnyObject] {
      watermarkConfig = WatermarkConfig(dictionary: watermarkDictionary)
    } else {
      watermarkConfig = nil
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
