//
//  ToggleButtonConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/15/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

public class ToggleButtonConfig: ElementConfig {
  public let width: CGFloat
  public let height: CGFloat
  public let image: UIImage?
  public let tintColor: UIColor
  public let toggledImage: UIImage?
  public let toggledTintColor: UIColor

  public convenience init() {
    self.init(dictionary: [String: AnyObject]())
  }

  public override init(dictionary: [String: AnyObject]) {
    let identifier = dictionary["identifier"] as? String
    
    width = (dictionary["width"] as? CGFloat) ?? 40
    height = (dictionary["height"] as? CGFloat) ?? 40

    let mobilePlayerBundle = NSBundle(forClass: ToggleButtonConfig.self)
    if let imageName = dictionary["image"] as? String {
      image = UIImage(named: imageName)
    } else if identifier == "play" {
      image = UIImage(named: "MLPlayButton", inBundle: mobilePlayerBundle, compatibleWithTraitCollection: nil)
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
    } else if identifier == "play" {
      toggledImage = UIImage(named: "MLPauseButton", inBundle: mobilePlayerBundle, compatibleWithTraitCollection: nil)
    } else {
      toggledImage = nil
    }
    
    if let toggledTintColorHex = dictionary["toggledTintColor"] as? String {
      toggledTintColor = UIColor(hex: toggledTintColorHex)
    } else {
      toggledTintColor = UIColor.whiteColor()
    }

    super.init(dictionary: dictionary)
  }
}
