//
//  CustomTimeSliderView.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 04/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

class CustomTimeSliderView: UIView {

  var maximumValue: Float {
    set{
      timeSlider.maximumValue = newValue
    }
    get {
      return timeSlider.maximumValue
    }
  }

  var minimumValue: Float {
    set{
      timeSlider.minimumValue = newValue
    }
    get {
      return timeSlider.minimumValue
    }
  }

  var value: Float {
    set {
      timeSlider.value = newValue
    }
    get{
      return timeSlider.value
    }
  }

  private var userInteraction: Bool = false
  private var userInteractionLocation: CGFloat = 0.0
  private var videoPercentRatio: CGFloat = 0.0
  private var bufferPercentRatio: CGFloat = 0.0
  private var customTimeSliderProgressValue: CGFloat = 0.0
  private var customTimeSliderThumbValue: CGFloat = 0.0
  var railView = UIView(frame: CGRectZero)
  var bufferView = UIView(frame: CGRectZero)
  var progressView = UIView(frame: CGRectZero)
  var thumbView = UIView(frame: CGRectZero)
  let timeSlider = UISlider(frame: CGRectZero)

  override init(frame: CGRect) {
    super.init(frame: frame)
    railView.backgroundColor = UIColor.lightGrayColor()
    addSubview(self.railView)
    bufferView.backgroundColor = UIColor.darkGrayColor()
    railView.addSubview(bufferView)
    progressView.backgroundColor = UIColor.blueColor()
    railView.addSubview(progressView)
    thumbView.backgroundColor = UIColor.lightGrayColor()
    addSubview(thumbView)
    railView.layer.masksToBounds = true
    thumbView.addGestureRecognizer(
      UIPanGestureRecognizer(
        target: self,
        action: "didTapSliderAction:"
      )
    )
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func didTapSliderAction(recognizer: UIPanGestureRecognizer!) {
    userInteraction = true
    let locationInView = recognizer.locationInView(railView)
    let thumbViewWidth = thumbView.frame.size.width
    let railViewWidth = railView.frame.size.width
    if recognizer.state == .Began {
      NSNotificationCenter.defaultCenter().postNotificationName("pauseVideoPlayer", object: nil)
    }
    if recognizer.state == .Changed {
      if locationInView.x < 0 {
        customTimeSliderThumbValue = -thumbViewWidth/2
      } else if locationInView.x + thumbViewWidth/2 >= railViewWidth {
        customTimeSliderThumbValue = railViewWidth - thumbViewWidth/2
      } else {
        customTimeSliderThumbValue = locationInView.x
        customTimeSliderProgressValue = locationInView.x + thumbViewWidth/2
        userInteractionLocation = locationInView.x
      }
    }
    if recognizer.state == .Ended {
      var currentPercent = CGFloat(locationInView.x / railViewWidth * 100)
      var videoPercent = CGFloat(currentPercent * CGFloat(timeSlider.maximumValue)) / 100
      var time: NSTimeInterval = NSTimeInterval(Float(videoPercent))
      NSNotificationCenter.defaultCenter().postNotificationName(
        "goToCustomTimeSliderWithTime",
        object: self,
        userInfo: ["time":time]
      )
      userInteraction = false
    }
  }

  //Buffer Percent
  func refreshBufferPercentRatio(bufferRatio width: CGFloat,totalDuration total: CGFloat) {
    if width.isNaN || total.isNaN {
      return bufferPercentRatio = 0.0
    }
    videoPercentRatio = CGFloat(width / total * 100)
    var bufferPercent: CGFloat = videoPercentRatio * self.bounds.size.width / 100
    bufferPercentRatio = CGFloat(NSString(format: "%0.2f",videoPercentRatio * self.bounds.size.width / 100).floatValue)
    layoutSubviews()
  }

  //Video Percent
  func refreshVideoProgressPercentRaito(videoRaito ratio: CGFloat, totalDuration total: CGFloat) {
    if !userInteraction {
      if ratio.isNaN || total.isNaN || (ratio / total * 100).isNaN {
        customTimeSliderProgressValue = 0.0
      } else {
        customTimeSliderProgressValue = ratio / total * 100
      }
      customTimeSliderProgressValue =
        customTimeSliderProgressValue * self.bounds.size.width / 100
    } else {
      customTimeSliderProgressValue = userInteractionLocation
    }
    layoutSubviews()
  }

  func refreshCustomTimeSliderPercentRatio() {
    if userInteraction {
      customTimeSliderThumbValue = userInteractionLocation
    } else {
      customTimeSliderThumbValue =
        progressView.frame.size.width - thumbView.frame.size.width/2
    }
  }

  override func layoutSubviews() {
    let size = bounds.size
    if bufferPercentRatio.isNaN {
      self.bufferPercentRatio = 0.0
    }
    if self.bufferPercentRatio.isNaN {
      self.bufferPercentRatio = 0.0
    }
    self.railView.frame = CGRect(
      x: 0.0,
      y: 18.0,
      width: self.frame.width - 2.0,
      height: 4.0)
    UIView.animateWithDuration(0.0, animations: {
      self.progressView.frame = CGRect(x: 0.0, y: 0.0,
        width: self.customTimeSliderProgressValue,
        height: 4.0)
    })
    UIView.animateWithDuration(
      0.0,
      delay: 0.0,
      options: .AllowUserInteraction,
      animations: { () -> Void in
        self.thumbView.frame = CGRect(x: self.customTimeSliderThumbValue,
          y: 8.0,
          width: 22.0,
          height: 22.0)
        self.thumbView.layer.cornerRadius = 11.0
        self.thumbView.layer.masksToBounds = true
        self.thumbView.layer.borderColor = UIColor.grayColor().CGColor
        self.thumbView.layer.borderWidth = 1.0
      }) { (Bool) -> Void in}
    UIView.animateWithDuration(0.1, animations: {
      self.bufferView.frame = CGRect(
        x: 0.0,
        y: 0.0,
        width: self.bufferPercentRatio,
        height: 4.0)
    })
  }
}
