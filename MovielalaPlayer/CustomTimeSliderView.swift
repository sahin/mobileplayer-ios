//
//  CustomTimeSliderView.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 04/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

class CustomTimeSliderView: UIView {
  
  var userInteraction:Bool = false
  var userInteractionLocation:CGFloat = 0.0
  var videoPercentRatio:CGFloat = 0.0
  var bufferPercentRatio:CGFloat = 0.0
  var customTimeSliderProgressValue:CGFloat = 0.0
  var customTimeSliderThumbValue:CGFloat = 0.0
  
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
    addSubview(bufferView)
    progressView.backgroundColor = UIColor.blueColor()
    addSubview(progressView)
    thumbView.backgroundColor = UIColor.lightGrayColor()
    addSubview(thumbView)
    
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
        bufferPercentRatio = locationInView.x
      }
    }
    if recognizer.state == .Ended {
      var currentPercent = CGFloat(locationInView.x / railViewWidth * 100)
      var videoPercent = CGFloat(currentPercent * CGFloat(timeSlider.maximumValue)) / 100
      var time:NSTimeInterval = NSTimeInterval(Float(videoPercent))
      NSNotificationCenter.defaultCenter().postNotificationName(
        "goToCustomTimeSliderWithTime",
        object: self,
        userInfo: ["time":time]
      )
      userInteraction = false
    }
  }
  
  // Buffer Percent
  func refreshBufferPercentRatio(bufferRatio width:CGFloat,totalDuration total:CGFloat) {
    if width.isNaN || total.isNaN {
      return bufferPercentRatio = 0.0
    }
    videoPercentRatio = CGFloat(width / total * 100)
    var bufferPercent:CGFloat = videoPercentRatio * self.bounds.size.width / 100
    bufferPercentRatio = bufferPercent
    layoutSubviews()
  }
  
  // Video Percent
  func refreshVideoProgressPercentRaito(videoRaito ratio:CGFloat, totalDuration total:CGFloat) {
    if !userInteraction {
      if ratio.isNaN || total.isNaN || (ratio / total * 100).isNaN {
        customTimeSliderProgressValue = 0.0
      } else {
        customTimeSliderProgressValue = CGFloat(ratio / total * 100)
      }
      customTimeSliderProgressValue = customTimeSliderProgressValue * self.bounds.size.width / 100
    }else{
      customTimeSliderProgressValue = userInteractionLocation
    }
    layoutSubviews()
  }
  
  func refreshCustomTimeSliderPercentRatio() {
    if userInteraction {
      customTimeSliderThumbValue = userInteractionLocation
    } else {
      customTimeSliderThumbValue = progressView.frame.size.width - thumbView.frame.size.width/2
    }
  }
  
  override func layoutSubviews() {
    
  }
  
  func getMaximumValue() -> Float {
    return timeSlider.maximumValue
  }
  
  func setMaximumValue(value:Float) {
    timeSlider.maximumValue = value
  }
  
  func getMinimumValue() -> Float {
    return timeSlider.minimumValue
  }
  
  func setMinimumValue(value:Float) {
    timeSlider.minimumValue = value
  }
  
  func setValue(value:Float) {
    timeSlider.value = value
  }
  
  func getValue() -> Float {
    return timeSlider.value
  }
  
}
