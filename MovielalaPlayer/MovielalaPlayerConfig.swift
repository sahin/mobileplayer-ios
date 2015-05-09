//
//  MovielalaPlayerConfig.swift
//  MovielalaPlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public struct MovielalaPlayerConfig {
  // MARK: - Special Callbacks
  public var firstPlayCallback: ((playerVC: MovielalaPlayerViewController) -> Void)? = nil
  public var shareCallback: ((playerVC: MovielalaPlayerViewController) -> Void)? = nil
  // MARK: - General Callbacks
  public var playCallback: ((playerVC: MovielalaPlayerViewController) -> Void)? = nil
  public var pauseCallback: ((playerVC: MovielalaPlayerViewController) -> Void)? = nil
  public var endCallback: ((playerVC: MovielalaPlayerViewController) -> Void)? = nil
  // MARK: - Overlays
  public var prerollViewController: MovielalaPlayerOverlayViewController? = nil
  public var pauseViewController: MovielalaPlayerOverlayViewController? = nil
  public var postrollViewController: MovielalaPlayerOverlayViewController? = nil
  // MARK: - Theming
  public var headerHeight = CGFloat(40)
  public var footerHeight = CGFloat(40)
  public var headerBorderHeight = CGFloat(1)
  public var headerBackgroundColor = UIColor(white: 0, alpha: 0.7)
  public var headerBorderColor = UIColor(white: 1, alpha: 0.2)
  public var footerBorderHeight = CGFloat(1)
  public var footerBackgroundColor = UIColor(white: 0, alpha: 0.7)
  public var footerBorderColor = UIColor(white: 1, alpha: 0.2)
  public var closeButtonImage = MovielalaPlayerConfig.loadImage(named: "MLCloseButton")
  public var closeButtonTintColor = UIColor.whiteColor()
  public var titleFont = UIFont.systemFontOfSize(16)
  public var titleColor = UIColor.whiteColor()
  public var shareButtonImage = MovielalaPlayerConfig.loadImage(named: "MLShareButton")
  public var shareButtonTintColor = UIColor.whiteColor()
  public var playButtonImage = MovielalaPlayerConfig.loadImage(named: "MLPlayButton")
  public var playButtonTintColor = UIColor.whiteColor()
  public var pauseButtonImage = MovielalaPlayerConfig.loadImage(named: "MLPauseButton")
  public var pauseButtonTintColor = UIColor.whiteColor()
  public var timeTextFont = UIFont.systemFontOfSize(14)
  public var timeTextColor = UIColor.whiteColor()

  // MARK: - Not Configuration Related

  public init() {}

  /// Loads an image from the player's resource bundle.
  private static func loadImage(#named: String) -> UIImage {
    return UIImage(
      named: named,
      inBundle: NSBundle(forClass: MovielalaPlayerViewController.self),
      compatibleWithTraitCollection: nil)!
  }
}
