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
  let shareConfig: ShareConfig
  let closeConfig: CloseConfig
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
    shareConfig = ShareConfig()
    closeConfig = CloseConfig()
    titleConfig = TitleConfig()
  }
  
  public init(dictionary: [String: AnyObject]) {
    
    if let controlbarObject = dictionary["controlbar"] as? [String: AnyObject] {
      controlbarConfig = ControlbarConfig(dictionary: controlbarObject)
    } else {
      controlbarConfig = ControlbarConfig()
    }
    
    if let shareObject = dictionary["share"] as? [String: AnyObject] {
      shareConfig = ShareConfig(dictionary: shareObject)
    } else {
      shareConfig = ShareConfig()
    }
    
    if let titleObject = dictionary["title"] as? [String: AnyObject] {
      titleConfig = TitleConfig(dictionary: titleObject)
    } else {
      titleConfig = TitleConfig()
    }
    
    if let closeObject = dictionary["close"] as? [String: AnyObject] {
      closeConfig = CloseConfig(dictionary: closeObject)
    } else {
      closeConfig = CloseConfig()
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
