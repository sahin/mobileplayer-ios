//
//  MobilePlayerConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct MobilePlayerConfig {

  // MARK: - ControlBar Skin
  public let controlbarConfig: ControlbarConfig
  public let shareConfig: ShareButtonConfig
  public let closeConfig: CloseButtonConfig
  public let titleConfig: TitleConfig

  // MARK: - Theming
  public var headerHeight = CGFloat(40)
  public var footerHeight = CGFloat(40)
  public var headerBorderHeight = CGFloat(1)
  public var headerBackgroundColor = UIColor(white: 0, alpha: 0.7)
  public var headerBorderColor = UIColor(white: 1, alpha: 0.2)
  public var footerBorderHeight = CGFloat(1)
  public var footerBackgroundColor = UIColor(white: 0, alpha: 0.7)
  public var footerBorderColor = UIColor(white: 1, alpha: 0.2)

  // MARK: - General Callbacks
  var playCallback: ((playerVC: MobilePlayerViewController) -> Void)? = nil
  var pauseCallback: ((playerVC: MobilePlayerViewController) -> Void)? = nil

  // MARK: - Overlays
  public var prerollViewController: MobilePlayerOverlayViewController? = nil
  public var pauseViewController: MobilePlayerOverlayViewController? = nil
  public var postrollViewController: MobilePlayerOverlayViewController? = nil
  public var endCallback: ((playerVC: MobilePlayerViewController) -> Void)? = nil

  // MARK: - Special Callbacks
  var firstPlayCallback: ((playerVC: MobilePlayerViewController) -> Void)? = nil

  // MARK: - Not Configuration Related
  public init() {
    controlbarConfig = ControlbarConfig()
    shareConfig = ShareButtonConfig()
    closeConfig = CloseButtonConfig()
    titleConfig = TitleConfig()
  }

  public init(dictionary: [String: AnyObject]) {
    if let controlbarConfigDictionary = dictionary["controlbar"] as? [String: AnyObject] {
      controlbarConfig = ControlbarConfig(dictionary: controlbarConfigDictionary)
    } else {
      controlbarConfig = ControlbarConfig()
    }
    if let shareConfigDictionary = dictionary["share"] as? [String: AnyObject] {
      shareConfig = ShareButtonConfig(dictionary: shareConfigDictionary)
    } else {
      shareConfig = ShareButtonConfig()
    }
    if let titleConfigDictionary = dictionary["title"] as? [String: AnyObject] {
      titleConfig = TitleConfig(dictionary: titleConfigDictionary)
    } else {
      titleConfig = TitleConfig()
    }
    if let closeButtonConfigDictionary = dictionary["closeButton"] as? [String: AnyObject] {
      closeConfig = CloseButtonConfig(dictionary: closeButtonConfigDictionary)
    } else {
      closeConfig = CloseButtonConfig()
    }
  }

  /// Loads an image from the player's resource bundle.
  static func loadImage(#named: String) -> UIImage {
    return UIImage(
      named: named,
      inBundle: NSBundle(forClass: MobilePlayerViewController.self),
      compatibleWithTraitCollection: nil)!
  }
}
