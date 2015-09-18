//
//  MobilePlayerConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct MobilePlayerConfig {
  public let watermark: WatermarkConfig?
  public let topBarConfig: BarConfig
  public let bottomBarConfig: BarConfig

  var playCallback: ((playerVC: MobilePlayerViewController) -> Void)? = nil
  var pauseCallback: ((playerVC: MobilePlayerViewController) -> Void)? = nil

  public var prerollViewController: MobilePlayerOverlayViewController? = nil
  public var pauseViewController: MobilePlayerOverlayViewController? = nil
  public var postrollViewController: MobilePlayerOverlayViewController? = nil

  public var firstPlayCallback: ((playerVC: MobilePlayerViewController) -> Void)? = nil
  public var endCallback: ((playerVC: MobilePlayerViewController) -> Void)? = nil

  public init() {
    self.init(dictionary: ())
  }

  public init(dictionary: [String: AnyObject]) {

  }
}
