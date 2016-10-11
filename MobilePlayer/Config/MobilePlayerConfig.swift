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
    self.init(dictionary: [String: Any]())
  }

  /// Initializes using a configuration JSON file.
  ///
  /// - parameters:
  ///   - fileURL: URL indicating the location of the configuration file.
  public convenience init(fileURL: URL) {
    if
      let jsonString = (try? String(contentsOf: fileURL, encoding: String.Encoding.utf8)),
      let jsonData = jsonString.data(using: String.Encoding.utf8),
      let dictionary = (try? JSONSerialization.jsonObject(with: jsonData, options: [])) as? [String: AnyObject] {
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
  public init(dictionary: [String: Any]) {
    // Values need to be AnyObject for type conversions to work correctly.
    let dictionary = dictionary as [String: AnyObject]

    if let watermarkDictionary = dictionary["watermark"] as? [String: Any] {
      watermarkConfig = WatermarkConfig(dictionary: watermarkDictionary)
    } else {
      watermarkConfig = nil
    }

    if let topBarDictionary = dictionary["topBar"] as? [String: Any] {
      topBarConfig = BarConfig(dictionary: topBarDictionary)
    } else {
      topBarConfig = BarConfig()
    }

    if let bottomBarDictionary = dictionary["bottomBar"] as? [String: Any] {
      bottomBarConfig = BarConfig(dictionary: bottomBarDictionary)
    } else {
      bottomBarConfig = BarConfig()
    }
  }
}
