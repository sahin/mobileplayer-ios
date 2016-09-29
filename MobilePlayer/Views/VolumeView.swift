//
//  VolumeView.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 25/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MediaPlayer

private let defaultIncreaseVolumeTintColor = UIColor.black
private let defaultReduceVolumeTintColor = UIColor.black

class VolumeView: UIView {
  let volumeSlider = MPVolumeView(frame: CGRect(x: -22, y: 50, width: 110, height: 50))
  let increaseVolumeImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
  let reduceVolumeImage = UIImageView(frame: CGRect(x: 10, y: 130, width: 20, height: 20))

  init(
    increaseVolumeTintColor: UIColor = defaultIncreaseVolumeTintColor,
    reduceVolumeTintColor: UIColor = defaultReduceVolumeTintColor) {
      super.init(frame: .zero)
      layer.cornerRadius = 5
      layer.borderColor = UIColor.gray.cgColor
      layer.borderWidth = 0.5
      layer.masksToBounds = true
      backgroundColor = UIColor.white
      volumeSlider.transform = CGAffineTransform(rotationAngle: .pi / -2)
      volumeSlider.showsRouteButton = false
      addSubview(volumeSlider)
      increaseVolumeImage.contentMode = .scaleAspectFit
      increaseVolumeImage.image = UIImage(podResourceNamed: "MLIncreaseVolume")?.template
      increaseVolumeImage.tintColor = increaseVolumeTintColor
      addSubview(increaseVolumeImage)
      reduceVolumeImage.contentMode = .scaleAspectFit
      reduceVolumeImage.image = UIImage(podResourceNamed: "MLReduceVolume")?.template
      reduceVolumeImage.tintColor = reduceVolumeTintColor
      addSubview(reduceVolumeImage)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
