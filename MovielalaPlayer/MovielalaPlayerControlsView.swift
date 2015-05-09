//
//  MovielalaPlayerControlsView.swift
//  MovielalaPlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation
import MediaPlayer

final class MovielalaPlayerControlsView: UIView {
  var controlsHidden: Bool = false {
    // Hide/show controls animated.
    didSet(oldValue) {
      if oldValue != controlsHidden {
        UIView.animateWithDuration(0.2, animations: {
          self.layoutSubviews()
        })
      }
    }
  }
  let headerView = UIView(frame: CGRectZero)
  let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
  let overlayContainerView = UIView(frame: CGRectZero)
  let footerView = UIView(frame: CGRectZero)
  let closeButton = UIButton(frame: CGRectZero)
  let titleLabel = UILabel(frame: CGRectZero)
  let shareButton = UIButton(frame: CGRectZero)
  let headerBorderView = UIView(frame: CGRectZero)
  let playButton = UIButton(frame: CGRectZero)
  let playbackTimeLabel = UILabel(frame: CGRectZero)
  let timeSlider = UISlider(frame: CGRectZero)
  let durationLabel = UILabel(frame: CGRectZero)
  let footerBorderView = UIView(frame: CGRectZero)
  private let config: MovielalaPlayerConfig

  init(config: MovielalaPlayerConfig) {
    self.config = config
    super.init(frame: CGRectZero)
    initializeHeaderViews()
    initializeOverlayViews()
    initializeFooterViews()
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("storyboards are incompatible with truth and beauty")
  }

  private func initializeHeaderViews() {
    headerView.backgroundColor = config.headerBackgroundColor
    addSubview(headerView)
    closeButton.setImage(config.closeButtonImage, forState: .Normal)
    closeButton.tintColor = config.closeButtonTintColor
    headerView.addSubview(closeButton)
    titleLabel.font = config.titleFont
    titleLabel.textColor = config.titleColor
    headerView.addSubview(titleLabel)
    shareButton.setImage(config.shareButtonImage, forState: .Normal)
    shareButton.tintColor = config.shareButtonTintColor
    headerView.addSubview(shareButton)
    headerBorderView.backgroundColor = config.headerBorderColor
    headerView.addSubview(headerBorderView)
  }

  private func initializeOverlayViews() {
    activityIndicatorView.hidesWhenStopped = true
    addSubview(activityIndicatorView)
    activityIndicatorView.startAnimating()
    overlayContainerView.backgroundColor = UIColor.clearColor()
    overlayContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
    addSubview(overlayContainerView)
  }

  private func initializeFooterViews() {
    footerView.backgroundColor = config.footerBackgroundColor
    addSubview(footerView)
    playButton.setImage(config.playButtonImage, forState: .Normal)
    playButton.tintColor = config.playButtonTintColor
    footerView.addSubview(playButton)
    playbackTimeLabel.text = "-:-"
    playbackTimeLabel.textAlignment = .Center
    playbackTimeLabel.font = config.timeTextFont
    playbackTimeLabel.textColor = config.timeTextColor
    footerView.addSubview(playbackTimeLabel)
    footerView.addSubview(timeSlider)
    durationLabel.text = "-:-"
    durationLabel.textAlignment = .Center
    durationLabel.font = config.timeTextFont
    durationLabel.textColor = config.timeTextColor
    footerView.addSubview(durationLabel)
    footerBorderView.backgroundColor = config.footerBorderColor
    footerView.addSubview(footerBorderView)
  }

  override func layoutSubviews() {
    let size = bounds.size
    headerView.frame = CGRect(
      x: 0,
      y: controlsHidden ? -config.headerHeight : 0,
      width: size.width,
      height: config.headerHeight)
    headerView.alpha = controlsHidden ? 0 : 1
    overlayContainerView.frame = CGRect(
      x: 0,
      y: controlsHidden ? 0 : config.headerHeight,
      width: size.width,
      height: controlsHidden ? size.height : size.height - config.headerHeight - config.footerHeight)
    for overlayView in overlayContainerView.subviews as! [UIView] {
      overlayView.frame = overlayContainerView.bounds
    }
    footerView.frame = CGRect(
      x: 0,
      y: size.height - (controlsHidden ? 0 : config.footerHeight),
      width: size.width,
      height: config.footerHeight)
    footerView.alpha = controlsHidden ? 0 : 1
    activityIndicatorView.sizeToFit()
    activityIndicatorView.center = overlayContainerView.center
    layoutHeaderSubviews()
    layoutFooterSubviews()
  }

  private func layoutHeaderSubviews() {
    let size = headerView.bounds.size
    closeButton.sizeToFit()
    let closeButtonSize = CGSize(
      width: config.headerHeight * closeButton.bounds.aspectRatio + 16,
      height: config.headerHeight)
    closeButton.frame = CGRect(origin: CGPointZero, size: closeButtonSize)
    shareButton.sizeToFit()
    let shareButtonSize = CGSize(
      width: config.headerHeight * shareButton.bounds.aspectRatio + 16,
      height: config.headerHeight)
    shareButton.frame = CGRect(
      origin: CGPoint(x: size.width - shareButtonSize.width, y: 0),
      size: shareButtonSize)
    titleLabel.frame = CGRect(
      x: closeButton.bounds.size.width,
      y: 0,
      width: size.width - closeButton.bounds.width - shareButton.bounds.width,
      height: size.height)
    headerBorderView.frame = CGRect(
      x: 0,
      y: size.height - config.headerBorderHeight,
      width: size.width,
      height: config.headerBorderHeight)
  }

  private func layoutFooterSubviews() {
    let size = footerView.bounds.size
    playButton.sizeToFit()
    let playButtonSize = CGSize(
      width: config.footerHeight * playButton.bounds.aspectRatio + 16,
      height: config.footerHeight)
    playButton.frame = CGRect(origin: CGPointZero, size: playButtonSize)
    playbackTimeLabel.sizeToFit()
    let playbackTimeLabelSize = CGSize(
      width: playbackTimeLabel.bounds.width + 16,
      height: config.footerHeight)
    playbackTimeLabel.frame = CGRect(
      origin: CGPoint(x: playButton.bounds.width, y: 0),
      size: playbackTimeLabelSize)
    durationLabel.sizeToFit()
    let durationLabelSize = CGSize(
      width: durationLabel.bounds.width + 16,
      height: config.footerHeight)
    durationLabel.frame = CGRect(
      origin: CGPoint(x: size.width - durationLabelSize.width, y: 0),
      size: durationLabelSize)
    timeSlider.sizeToFit()
    let timeSliderSize = CGSize(
      width: size.width - playButton.bounds.width - playbackTimeLabel.bounds.width - durationLabel.bounds.width,
      height: config.footerHeight)
    timeSlider.frame = CGRect(
      origin: CGPoint(x: playButton.bounds.width + playbackTimeLabel.bounds.width, y: 0),
      size: timeSliderSize)
    footerBorderView.frame = CGRect(
      x: 0,
      y: 0,
      width: size.width,
      height: config.footerBorderHeight)
  }
}
