//
//  SoundControlView.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 25/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MediaPlayer

private let defaultIncreaseVolumeTintColor = UIColor.blackColor()
private let defaultReduceVolumeTintColor = UIColor.blackColor()

class VolumeControlView: UIView {
  let volumeSlider = MPVolumeView(frame: CGRect(x: -22, y: 50, width: 110, height: 50))
  let increaseVolumeImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
  let reduceVolumeImage = UIImageView(frame: CGRect(x: 10, y: 130, width: 20, height: 20))

  init(
    increaseVolumeTintColor: UIColor = defaultIncreaseVolumeTintColor,
    reduceVolumeTintColor: UIColor = defaultReduceVolumeTintColor) {
      super.init(frame: CGRectZero)
      layer.cornerRadius = 5
      layer.borderColor = UIColor.grayColor().CGColor
      layer.borderWidth = 0.5
      layer.masksToBounds = true
      backgroundColor = UIColor.whiteColor()
      volumeSlider.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
      volumeSlider.showsVolumeSlider = true
      volumeSlider.showsRouteButton = false
      addSubview(volumeSlider)
      increaseVolumeImage.image = UIImage(named: "MLIncreaseVolume")
      increaseVolumeImage.tintAdjustmentMode = .Normal
      addSubview(increaseVolumeImage)
      reduceVolumeImage.image = UIImage(named: "MLReduceVolume")
      reduceVolumeImage.tintAdjustmentMode = .Normal
      increaseVolumeImage.tintColor = increaseVolumeTintColor
      reduceVolumeImage.tintColor = reduceVolumeTintColor
      addSubview(reduceVolumeImage)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
