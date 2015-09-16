//
//  ToggleButtonConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/15/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

class ToggleButtonConfig {
  let identifier: String?
  let width: CGFloat
  let height: CGFloat
  let image: UIImage?
  let tintColor: UIColor
  let toggledImage: UIImage?
  let toggledTintColor: UIColor

  convenience init() {
    self.init(dictionary: [String: AnyObject]())
  }

  init(dictionary: [String: AnyObject]) {
    identifier = dictionary["identifier"] as? String
    width = (dictionary["width"] as? CGFloat) ?? 40
    height = (dictionary["height"] as? CGFloat) ?? 40

    if let imageName = dictionary["image"] as? String {
      image = UIImage(named: imageName)
    } else {
      image = nil
    }

    if let tintColorHex = dictionary["tintColor"] as? String {
      tintColor = UIColor(hex: tintColorHex)
    } else {
      tintColor = UIColor.whiteColor()
    }

    if let toggledImageName = dictionary["toggledImage"] as? String {
      toggledImage = UIImage(named: toggledImageName)
    } else {
      toggledImage = nil
    }
    
    if let toggledTintColorHex = dictionary["toggledTintColor"] as? String {
      toggledTintColor = UIColor(hex: toggledTintColorHex)
    } else {
      toggledTintColor = UIColor.whiteColor()
    }
  }
}
