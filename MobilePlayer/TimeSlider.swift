//
//  TimeSlider.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 04/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

protocol TimeSliderDelegate: class {
  func timeSliderSeekDidBegin(timeSlider: TimeSlider)
  func timeSliderDidSeek(timeSlider: TimeSlider)
  func timeSliderSeekDidEnd(timeSlider: TimeSlider)
}

class TimeSlider: UIView {
  var delegate: TimeSliderDelegate?
  var minimumValue = NSTimeInterval(0) { didSet { setNeedsLayout() } }
  var value = NSTimeInterval(0)        { didSet { setNeedsLayout() } }
  var bufferValue = NSTimeInterval(0)  { didSet { setNeedsLayout() } }
  var maximumValue = NSTimeInterval(1) { didSet { setNeedsLayout() } }

  let railView = UIView(frame: CGRectZero)
  var railViewHeight = CGFloat(2)                     { didSet { setNeedsLayout() } }
  var railViewRadius = CGFloat(1)                     { didSet { setNeedsLayout() } }
  let progressView = UIView(frame: CGRectZero)
  let bufferView = UIView(frame: CGRectZero)
  let thumbView = UIView(frame: CGRectZero)
  var thumbViewWidth = CGFloat(22)                { didSet { setNeedsLayout() } }
  var thumbViewHeight = CGFloat(22)               { didSet { setNeedsLayout() } }
  var thumbViewRadius = CGFloat(11)               { didSet { setNeedsLayout() } }
  var thumbViewBorderWidth = CGFloat(1)           { didSet { setNeedsLayout() } }
  var thumbViewBorderColor = UIColor.blackColor() { didSet { setNeedsLayout() } }

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    railView.backgroundColor = UIColor.lightGrayColor()
    railView.clipsToBounds = true
    addSubview(railView)
    bufferView.backgroundColor = UIColor.darkGrayColor()
    bufferView.clipsToBounds = true
    railView.addSubview(bufferView)
    progressView.backgroundColor = UIColor.blueColor()
    railView.addSubview(progressView)
    thumbView.backgroundColor = UIColor.lightGrayColor()
    thumbView.clipsToBounds = true
    thumbView.accessibilityLabel = "Thumb"
    addSubview(thumbView)
    thumbView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "didPanThumbView:"))
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setters

  func setValue(value: NSTimeInterval, animated: Bool, duration: NSTimeInterval) {
    self.value = value
    if animated {
      UIView.animateWithDuration(
        duration,
        delay: 0,
        options: .AllowUserInteraction,
        animations: {
          self.layoutIfNeeded()
        },
        completion: nil)
    }
  }

  func setBufferValue(bufferValue: NSTimeInterval, animated: Bool, duration: NSTimeInterval) {
    self.bufferValue = bufferValue
    if animated {
      UIView.animateWithDuration(
        duration,
        animations: {
          self.layoutIfNeeded()
      })
    }
  }

  // MARK: - Seeking

  func didPanThumbView(recognizer: UIPanGestureRecognizer!) {
    let locationInView = recognizer.locationInView(railView)
    let railViewWidth = railView.frame.size.width
    if recognizer.state == .Began {
      delegate?.timeSliderSeekDidBegin(self)
    }
    if recognizer.state == .Changed || recognizer.state == .Ended || recognizer.state == .Cancelled {
      var targetX = locationInView.x
      if targetX < 0 {
        targetX = 0
      } else if targetX > railViewWidth {
        targetX = railViewWidth
      }
      value = minimumValue + (maximumValue - minimumValue) * Double(targetX / railViewWidth)
      if recognizer.state == .Changed {
        delegate?.timeSliderDidSeek(self)
      } else {
        delegate?.timeSliderSeekDidEnd(self)
      }
    }
  }

  // MARK: - Layout

  override func layoutSubviews() {
    let size = bounds.size
    railView.frame = CGRect(x: 0, y: (size.height - railViewHeight) / 2, width: size.width, height: railViewHeight)
    railView.layer.cornerRadius = railViewRadius
    let realMaximumValue = maximumValue - minimumValue
    let progressViewWidth = realMaximumValue != 0 ? size.width * CGFloat((value - minimumValue) / realMaximumValue) : 0
    progressView.frame = CGRect(x: 0, y: 0, width: progressViewWidth, height: railViewHeight)
    let bufferViewWidth = realMaximumValue != 0 ? size.width * CGFloat((bufferValue - minimumValue) / realMaximumValue) : 0
    bufferView.frame = CGRect(x: 0, y: 0, width: bufferViewWidth, height: railViewHeight)
    bufferView.layer.cornerRadius = railView.layer.cornerRadius
    thumbView.frame = CGRect(x: progressViewWidth - thumbViewWidth / 2, y: (size.height - thumbViewHeight) / 2, width: thumbViewWidth, height: thumbViewHeight)
    thumbView.layer.cornerRadius = thumbViewRadius
    thumbView.layer.borderColor = thumbViewBorderColor.CGColor
    thumbView.layer.borderWidth = thumbViewBorderWidth
  }
}
