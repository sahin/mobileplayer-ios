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

  public var prerollViewController: MobilePlayerOverlayViewController? = nil
  public var pauseViewController: MobilePlayerOverlayViewController? = nil
  public var postrollViewController: MobilePlayerOverlayViewController? = nil

  public convenience init() {
    self.init(dictionary: [String: AnyObject]())
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
