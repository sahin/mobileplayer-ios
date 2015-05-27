//
//  MovielalaPlayerConfig.swift
//  MovielalaPlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct MovielalaPlayerConfig {

  // MARK: - ControlBar Skin 
  let controlbarConfig: ControlbarConfig
  let shareConfig: ShareButtonConfig
  let closeConfig: CloseButtonConfig
  let titleConfig: TitleConfig
  
  // MARK: - Theming
  var headerHeight = CGFloat(40)
  var footerHeight = CGFloat(40)
  var headerBorderHeight = CGFloat(1)
  var headerBackgroundColor = UIColor(white: 0, alpha: 0.7)
  var headerBorderColor = UIColor(white: 1, alpha: 0.2)
  var footerBorderHeight = CGFloat(1)
  var footerBackgroundColor = UIColor(white: 0, alpha: 0.7)
  var footerBorderColor = UIColor(white: 1, alpha: 0.2)
  var closeButtonImage = MovielalaPlayerConfig.loadImage(named: "MLCloseButton")
  var closeButtonTintColor = UIColor.whiteColor()
  var titleFont = UIFont.systemFontOfSize(16)
  var titleColor = UIColor.whiteColor()
  
  // MARK: - General Callbacks
  var playCallback: ((playerVC: MovielalaPlayerViewController) -> Void)? = nil
  var pauseCallback: ((playerVC: MovielalaPlayerViewController) -> Void)? = nil
  
  // MARK: - Overlays
  var prerollViewController: MovielalaPlayerOverlayViewController? = nil
  var pauseViewController: MovielalaPlayerOverlayViewController? = nil
  var postrollViewController: MovielalaPlayerOverlayViewController? = nil
  var endCallback: ((playerVC: MovielalaPlayerViewController) -> Void)? = nil
  
  // MARK: - Special Callbacks
  var firstPlayCallback: ((playerVC: MovielalaPlayerViewController) -> Void)? = nil
  
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
    if let closeButtonConfigDictionary = dictionary["close_button"] as? [String: AnyObject] {
      closeConfig = CloseButtonConfig(dictionary: closeButtonConfigDictionary)
    } else {
      closeConfig = CloseButtonConfig()
    }
  }

  /// Loads an image from the player's resource bundle.
  static func loadImage(#named: String) -> UIImage {
    return UIImage(
      named: named,
      inBundle: NSBundle(forClass: MovielalaPlayerViewController.self),
      compatibleWithTraitCollection: nil)!
  }
}
