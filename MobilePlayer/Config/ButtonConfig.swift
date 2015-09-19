//
//  ButtonConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/16/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

public class ButtonConfig: ElementConfig {
  public let height: CGFloat
  public let image: UIImage?
  public let tintColor: UIColor

  public convenience init() {
    self.init(dictionary: [String: AnyObject]())
  }

  public override init(dictionary: [String: AnyObject]) {
    height = (dictionary["height"] as? CGFloat) ?? 40

    if let imageName = dictionary["image"] as? String {
      image = UIImage(named: imageName)
    } else if let identifier = dictionary["identifier"] as? String {
      let mobilePlayerBundle = NSBundle(forClass: ButtonConfig.self)
      switch identifier {
      case "close":
        image = UIImage(named: "MLCloseButton", inBundle: mobilePlayerBundle, compatibleWithTraitCollection: nil)
      case "share":
        image = UIImage(named: "MLShareButton", inBundle: mobilePlayerBundle, compatibleWithTraitCollection: nil)
      default:
        image = nil
      }
    } else {
      image = nil
    }

    if let tintColorHex = dictionary["tintColor"] as? String {
      tintColor = UIColor(hex: tintColorHex)
    } else {
      tintColor = UIColor.whiteColor()
    }

    super.init(dictionary: dictionary)
  }
}
