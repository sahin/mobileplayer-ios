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
        UIView.animateWithDuration(0.0, animations: {
          self.layoutSubviews()
        })
      }
    }
  }
  
  var customTimeSliderView = UIView(frame: CGRectZero)
  var customTimeSliderRailView = UIView(frame: CGRectZero)// Rail Area
  var customTimeSliderBufferView = UIView(frame: CGRectZero)
  var customTimeSliderProgressView = UIView(frame: CGRectZero)
  var customTimeSliderThumbView = UIView(frame: CGRectZero)
  var videoPercentRatio:CGFloat = 0.0
  var screenPercentRatio:CGFloat = 0.0
  var customTimeSliderProgressValue:CGFloat = 0.0
  var customTimeSliderThumbValue:CGFloat = 0.0
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
    
    customTimeSliderThumbView.addGestureRecognizer(
      UIPanGestureRecognizer(
        target: self,
        action: "didTapCustomTimeSliderThumbView:"
      )
    )
    
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
    shareButton.setImage(config.shareConfig.shareButtonImage, forState: .Normal)
    shareButton.tintColor = config.shareConfig.shareButtonTintColor
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
    playButton.setImage(config.controlbarConfig.playButtonImage, forState: .Normal)
    playButton.tintColor = config.controlbarConfig.playButtonTintColor
    footerView.addSubview(playButton)
    playbackTimeLabel.text = "-:-"
    playbackTimeLabel.textAlignment = .Center
    playbackTimeLabel.font = config.controlbarConfig.timeTextFont
    playbackTimeLabel.textColor = config.controlbarConfig.timeTextColor
    footerView.addSubview(playbackTimeLabel)
    //footerView.addSubview(timeSlider)
    durationLabel.text = "-:-"
    durationLabel.textAlignment = .Center
    durationLabel.font = config.controlbarConfig.timeTextFont
    durationLabel.textColor = config.controlbarConfig.timeTextColor
    footerView.addSubview(durationLabel)
    footerBorderView.backgroundColor = config.footerBorderColor
    footerView.addSubview(footerBorderView)
    
    customTimeSliderView.backgroundColor = UIColor.clearColor()
    footerView.addSubview(customTimeSliderView)
    customTimeSliderRailView.backgroundColor = UIColor.lightGrayColor()
    customTimeSliderView.addSubview(customTimeSliderRailView)
    customTimeSliderBufferView.backgroundColor = UIColor.darkGrayColor()
    customTimeSliderView.addSubview(customTimeSliderBufferView)
    customTimeSliderProgressView.backgroundColor = UIColor.blueColor()
    customTimeSliderView.addSubview(customTimeSliderProgressView)
    customTimeSliderThumbView.backgroundColor = UIColor.lightGrayColor()
    customTimeSliderThumbView.userInteractionEnabled = true
    customTimeSliderView.addSubview(customTimeSliderThumbView)
    
  }
  
  func didTapCustomTimeSliderThumbView(recognizer: UIPanGestureRecognizer!) {
    NSNotificationCenter.defaultCenter().postNotificationName("pauseVideoPlayer", object: nil)
    let locationInView = recognizer.locationInView(customTimeSliderRailView)
    let thumbViewWidth = customTimeSliderThumbView.frame.size.width
    let railViewWidth = customTimeSliderRailView.frame.size.width
    if recognizer.state == UIGestureRecognizerState.Changed {
      if locationInView.x < 0 {
        customTimeSliderThumbValue = 0.0
      } else if locationInView.x >= railViewWidth {
        customTimeSliderThumbValue = railViewWidth - thumbViewWidth
      } else {
        customTimeSliderThumbValue = locationInView.x
      }
    }
    if recognizer.state == UIGestureRecognizerState.Ended {
      var currentPercent = CGFloat(locationInView.x / railViewWidth * 100)
      var videoPercent = CGFloat(currentPercent * CGFloat(timeSlider.maximumValue)) / 100
      var time:NSTimeInterval = NSTimeInterval(Float(videoPercent))
      NSNotificationCenter.defaultCenter().postNotificationName(
        "goToCustomTimeSliderWithTime",
        object: self,
        userInfo: ["time":time]
      )
    }
  }
  
  // Buffer Percent
  func refreshBufferPercentRatio(bufferRatio width:CGFloat,totalDuration total:CGFloat) {
    if width.isNaN || total.isNaN {
      return screenPercentRatio = 0.0
    }
    videoPercentRatio = CGFloat(width / total * 100)
    var screenPercent:CGFloat = videoPercentRatio * customTimeSliderView.bounds.size.width / 100
    screenPercentRatio = screenPercent
    layoutSubviews()
  }
  
  // Video Percent
  func refreshVideoProgressPercentRaito(videoRaito ratio:CGFloat, totalDuration total:CGFloat) {
    if ratio.isNaN || total.isNaN || (ratio / total * 100).isNaN {
      customTimeSliderProgressValue = 0.0
    } else {
      customTimeSliderProgressValue = CGFloat(ratio / total * 100)
    }
    var videoPercent:CGFloat = customTimeSliderProgressValue * customTimeSliderView.bounds.size.width / 100
    //TODO: Bug -> Line 172
    //customTimeSliderThumbValue = videoPercent - self.customTimeSliderThumbView.frame.width/2
    customTimeSliderProgressValue = videoPercent - self.customTimeSliderThumbView.frame.width/2
    layoutSubviews()
  }
  
  func refreshCustomTimeSliderPercentRatio() {
    customTimeSliderThumbValue = customTimeSliderProgressView.frame.size.width
  }
  
  override func layoutSubviews() {
    let size = bounds.size
    if self.screenPercentRatio.isNaN {
      screenPercentRatio = 0.0
    }
    
    // Buffer View
    UIView.animateWithDuration(0.0, animations: {
      self.customTimeSliderBufferView.frame = CGRect(
        x: 0.0,
        y: 18.0,
        width: self.screenPercentRatio,
        height: 4.0)
      //self.customTimeSliderBufferView.layer.cornerRadius = 5.0
      //self.customTimeSliderBufferView.layer.masksToBounds = true
    })
    
    // Rail View
    self.customTimeSliderRailView.frame = CGRect(
      x: 0.0,
      y: 18.0,
      width: customTimeSliderView.frame.width - 2.0,
      height: 4.0)
     //self.customTimeSliderRailView.layer.cornerRadius = 5.0
     //self.customTimeSliderRailView.layer.masksToBounds = true
    
    // Progress View
    UIView.animateWithDuration(0.0, animations: {
      self.customTimeSliderProgressView.frame = CGRect(
        x: 0.0,
        y: 18.0,
        width: self.customTimeSliderProgressValue,
        height: 4.0)
      //self.customTimeSliderProgressView.layer.cornerRadius = 5.0
      //self.customTimeSliderProgressView.layer.masksToBounds = true
    })
    
    // Thumb View
    UIView.animateWithDuration(0.0, animations: {
      self.customTimeSliderThumbView.frame = CGRect(
        x: self.customTimeSliderThumbValue,
        y: 8.0,
        width: 22.0,
        height: 22.0)
      self.customTimeSliderThumbView.layer.cornerRadius = 11.0
      self.customTimeSliderThumbView.layer.masksToBounds = true
      self.customTimeSliderThumbView.layer.borderColor = UIColor.grayColor().CGColor
      self.customTimeSliderThumbView.layer.borderWidth = 1.0
    })
    
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
    
    customTimeSliderView.sizeToFit()
    let customTimeSliderSize = CGSize(
      width: size.width - playButton.bounds.width - playbackTimeLabel.bounds.width - durationLabel.bounds.width - 20,
      height: config.footerHeight)
    customTimeSliderView.frame = CGRect(
      origin: CGPoint(x: playButton.bounds.width + playbackTimeLabel.bounds.width + 10, y: 0),
      size: customTimeSliderSize)
    
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
