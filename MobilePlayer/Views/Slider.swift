//
//  Slider.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/16/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

protocol SliderDelegate: class {
  func sliderThumbPanDidBegin(slider: Slider)
  func sliderThumbDidPan(slider: Slider)
  func sliderThumbPanDidEnd(slider: Slider)
}

class Slider: UIView {
  let config: SliderConfig
  var delegate: SliderDelegate?
  var minimumValue = Float(0)    { didSet { setNeedsLayout() } }
  var value = Float(0)           { didSet { setNeedsLayout() } }
  var availableValue = Float(0)  { didSet { setNeedsLayout() } }
  var maximumValue = Float(1)    { didSet { setNeedsLayout() } }

  let maximumTrack = UIView(frame: CGRectZero)
  let availableTrack = UIView(frame: CGRectZero)
  let minimumTrack = UIView(frame: CGRectZero)
  let thumb = UIView(frame: CGRectZero)

  // MARK: - Initialization

  init(config: SliderConfig = SliderConfig()) {
    self.config = config
    super.init(frame: CGRectZero)
    accessibilityLabel = accessibilityLabel ?? config.identifier
    maximumTrack.backgroundColor = config.maximumTrackTintColor
    maximumTrack.clipsToBounds = true
    maximumTrack.layer.cornerRadius = config.trackCornerRadius
    addSubview(maximumTrack)
    availableTrack.backgroundColor = config.availableTrackTintColor
    availableTrack.clipsToBounds = true
    availableTrack.layer.cornerRadius = config.trackCornerRadius
    maximumTrack.addSubview(availableTrack)
    minimumTrack.backgroundColor = config.minimumTrackTintColor
    maximumTrack.addSubview(minimumTrack)
    thumb.backgroundColor = config.thumbTintColor
    thumb.accessibilityLabel = "thumb"
    thumb.clipsToBounds = true
    thumb.layer.cornerRadius = config.thumbCornerRadius
    thumb.layer.borderColor = config.thumbBorderColor
    thumb.layer.borderWidth = config.thumbBorderWidth
    addSubview(thumb)
    thumb.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "didPanThumb:"))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setters

  func setValue(value: Float, animatedForDuration duration: NSTimeInterval) {
    self.value = value
    if duration > 0 {
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

  func setAvailableValue(availableValue: Float, animatedForDuration duration: NSTimeInterval) {
    self.availableValue = availableValue
    if duration > 0 {
      UIView.animateWithDuration(
        duration,
        animations: {
          self.layoutIfNeeded()
      })
    }
  }

  // MARK: - Seeking

  func didPanThumb(recognizer: UIPanGestureRecognizer!) {
    let locationInTrack = recognizer.locationInView(maximumTrack)
    let trackWidth = maximumTrack.frame.size.width
    if recognizer.state == .Began {
      delegate?.sliderThumbPanDidBegin(self)
    }
    if recognizer.state == .Changed || recognizer.state == .Ended || recognizer.state == .Cancelled {
      var targetX = locationInTrack.x
      if targetX < 0 {
        targetX = 0
      } else if targetX > trackWidth {
        targetX = trackWidth
      }
      value = minimumValue + (maximumValue - minimumValue) * Float(targetX / trackWidth)
      if recognizer.state == .Changed {
        delegate?.sliderThumbDidPan(self)
      } else {
        delegate?.sliderThumbPanDidEnd(self)
      }
    }
  }

  // MARK: - Layout

  override func sizeThatFits(size: CGSize) -> CGSize {
    let biggestHeight = config.thumbHeight > config.trackHeight ? config.thumbHeight : config.trackHeight
    let width = (config.widthCalculation == .AsDefined) ? config.width : config.thumbWidth * 2
    let height = size.height < biggestHeight ? biggestHeight : size.height
    return CGSize(width: width, height: height)
  }

  override func layoutSubviews() {
    let size = bounds.size
    maximumTrack.frame = CGRect(
      x: config.thumbWidth / 2,
      y: (size.height - config.trackHeight) / 2,
      width: size.width - config.thumbWidth,
      height: config.trackHeight)
    let realMaximumValue = maximumValue - minimumValue
    let minimumTrackWidth = realMaximumValue != 0 ? maximumTrack.frame.size.width * CGFloat((value - minimumValue) / realMaximumValue) : 0
    minimumTrack.frame = CGRect(x: 0, y: 0, width: minimumTrackWidth, height: config.trackHeight)
    let availableTrackWidth = realMaximumValue != 0 ? maximumTrack.frame.size.width * CGFloat((availableValue - minimumValue) / realMaximumValue) : 0
    availableTrack.frame = CGRect(x: 0, y: 0, width: availableTrackWidth, height: config.trackHeight)
    thumb.frame = CGRect(
      x: minimumTrackWidth,
      y: (size.height - config.thumbHeight) / 2,
      width: config.thumbWidth,
      height: config.thumbHeight)
  }
}

// MARK: - Element
extension Slider: Element {
  var type: ElementType { return config.type }
  var identifier: String? { return config.identifier }
  var widthCalculation: ElementWidthCalculation { return config.widthCalculation }
  var width: CGFloat { return config.width }
  var marginLeft: CGFloat { return config.marginLeft }
  var marginRight: CGFloat { return config.marginRight }
  var view: UIView { return self }
}
