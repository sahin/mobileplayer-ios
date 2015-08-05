//
//  TimeSliderView.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 04/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

class TimeSliderView: UIView {

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
  private var timeSliderProgressValue: CGFloat = 0.0
  private var timeSliderThumbValue: CGFloat = 0.0
  var railView = UIView(frame: CGRectZero)
  var railHeight: CGFloat = 2.0
  var bufferView = UIView(frame: CGRectZero)
  var progressView = UIView(frame: CGRectZero)
  var thumbView = UIView(frame: CGRectZero)
  var thumbViewRadius: CGFloat = 10.0
  var thumbHeight: CGFloat = 22.0
  var thumbWidth: CGFloat = 22.0
  var thumbBorder: CGFloat = 1.0
  var thumbBorderColor: UIColor = UIColor.blackColor()
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
        timeSliderThumbValue = -thumbViewWidth/2
      } else if locationInView.x + thumbViewWidth/2 >= railViewWidth {
        timeSliderThumbValue = railViewWidth - thumbViewWidth/2
      } else {
        timeSliderThumbValue = locationInView.x
        timeSliderProgressValue = locationInView.x + thumbViewWidth/2
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

  // Buffer Percent
  func refreshBufferPercentRatio(bufferRatio width: CGFloat,totalDuration total: CGFloat) {
    if width.isNaN || total.isNaN {
      return bufferPercentRatio = 0.0
    }
    videoPercentRatio = CGFloat(width / total * 100)
    var bufferPercent: CGFloat = videoPercentRatio * self.bounds.size.width / 100
    bufferPercentRatio = videoPercentRatio * self.bounds.size.width / 100
    layoutSubviews()
  }

  // Video Percent
  func refreshVideoProgressPercentRaito(videoRaito ratio: CGFloat, totalDuration total: CGFloat) {
    if !userInteraction {
      if ratio.isNaN || total.isNaN || (ratio / total * 100).isNaN {
        timeSliderProgressValue = 0.0
      } else {
        timeSliderProgressValue = ratio / total * 100
      }
      timeSliderProgressValue =
        timeSliderProgressValue * self.bounds.size.width / 100
    } else {
      timeSliderProgressValue = userInteractionLocation
    }
    layoutSubviews()
  }

  func refreshCustomTimeSliderPercentRatio() {
    if userInteraction {
      timeSliderThumbValue = userInteractionLocation
    } else {
      timeSliderThumbValue = progressView.frame.size.width - thumbView.frame.size.width/2
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
    self.railView.frame = CGRect(x: 0.0, y: 20.0 - self.railHeight / 2.0,
      width: self.frame.width - 2.0,
      height: self.railHeight)
    UIView.animateWithDuration(0.0, animations: {
      self.progressView.frame = CGRect(x: 0.0, y: 0.0,
        width: self.timeSliderProgressValue,
        height: self.railHeight)
    })
    UIView.animateWithDuration(0.0, delay: 0.0,
      options: .AllowUserInteraction,
      animations: { () -> Void in
        self.thumbView.frame = CGRect(x: self.timeSliderThumbValue,
          y: (self.railView.frame.yVal + self.railHeight / 2.0) - (self.thumbHeight / 2.0),
          width: self.thumbWidth,
          height: self.thumbHeight)
        self.thumbView.layer.cornerRadius = self.thumbViewRadius
        self.thumbView.layer.masksToBounds = true
        self.thumbView.layer.borderColor = self.thumbBorderColor.CGColor
        self.thumbView.layer.borderWidth = self.thumbBorder
      }) { (Bool) -> Void in}
    UIView.animateWithDuration(0.1, animations: {
      self.bufferView.frame = CGRect(x: 0.0, y: 0.0,
        width: self.bufferPercentRatio,
        height: self.railHeight)
      self.bufferView.layer.cornerRadius = self.railHeight / 2.0
      self.bufferView.layer.masksToBounds = true
    })
  }
}
