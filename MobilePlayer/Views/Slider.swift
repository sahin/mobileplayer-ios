//
//  Slider.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/16/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol SliderDelegate: class {
  func sliderThumbPanDidBegin(slider: Slider)
  func sliderThumbDidPan(slider: Slider)
  func sliderThumbPanDidEnd(slider: Slider)
}

// MARK: - Class
class Slider: UIView {
  let config: SliderConfig
  weak var delegate: SliderDelegate?
  var minimumValue: Float = 0    { didSet { setNeedsLayout() } }
  var value: Float = 0           { didSet { setNeedsLayout() } }
  var availableValue: Float = 0  { didSet { setNeedsLayout() } }
  var maximumValue: Float = 1    { didSet { setNeedsLayout() } }

  let maximumTrack = UIView(frame: .zero)
  let availableTrack = UIView(frame: .zero)
  let minimumTrack = UIView(frame: .zero)
  let thumb = UIView(frame: .zero)

  // MARK: Initialization

  init(config: SliderConfig = SliderConfig()) {
    self.config = config
    super.init(frame: .zero)
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
    thumb.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanThumb)))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setters

  func setValue(value: Float, animatedForDuration duration: TimeInterval) {
    self.value = value
    if duration > 0 {
      UIView.animate(
        withDuration: duration,
        delay: 0,
        options: .allowUserInteraction,
        animations: {
          self.layoutIfNeeded()
        },
        completion: nil)
    }
  }

  func setAvailableValue(availableValue: Float, animatedForDuration duration: TimeInterval) {
    self.availableValue = availableValue
    if duration > 0 {
      UIView.animate(
        withDuration: duration,
        animations: {
          self.layoutIfNeeded()
      })
    }
  }

  // MARK: Seeking

  @objc func didPanThumb(recognizer: UIPanGestureRecognizer!) {
    let locationInTrack = recognizer.location(in: maximumTrack)
    let trackWidth = maximumTrack.frame.size.width
    if recognizer.state == .began {
      delegate?.sliderThumbPanDidBegin(slider: self)
    }
    if recognizer.state == .changed || recognizer.state == .ended || recognizer.state == .cancelled {
      var targetX = locationInTrack.x
      if targetX < 0 {
        targetX = 0
      } else if targetX > trackWidth {
        targetX = trackWidth
      }
      value = minimumValue + (maximumValue - minimumValue) * Float(targetX / trackWidth)
      if recognizer.state == .changed {
        delegate?.sliderThumbDidPan(slider: self)
      } else {
        delegate?.sliderThumbPanDidEnd(slider: self)
      }
    }
  }

  // MARK: Layout

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let width = (config.widthCalculation == .AsDefined) ? config.width : size.width

    let minHeight = max(config.thumbHeight, config.trackHeight)
    let height    = (size.height < minHeight) ? minHeight : size.height

    return CGSize(width: width, height: height)
  }

  override func layoutSubviews() {
    let realMaximumValue   = max(0.00001, CGFloat(maximumValue - minimumValue))
    let realAvailableValue = max(0, min(realMaximumValue, CGFloat(availableValue - minimumValue)))
    let realValue          = max(0, min(realMaximumValue, CGFloat(value - minimumValue)))

    maximumTrack.frame = CGRect(
      x: 0,
      y: (bounds.height - config.trackHeight) / 2,
      width: bounds.width,
      height: config.trackHeight)

    availableTrack.frame = CGRect(
      x: 0,
      y: 0,
      width: maximumTrack.frame.width * (realAvailableValue / realMaximumValue),
      height: config.trackHeight)

    thumb.frame = CGRect(
      x: (bounds.width - config.thumbWidth) * (realValue / realMaximumValue),
      y: (bounds.height - config.thumbHeight) / 2,
      width: config.thumbWidth,
      height: config.thumbHeight)

    minimumTrack.frame = CGRect(
      x: 0,
      y: 0,
      width: thumb.frame.midX,
      height: config.trackHeight)
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
