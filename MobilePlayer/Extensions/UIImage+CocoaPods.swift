//
//  UIImage+CocoaPods.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 16/11/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit

extension UIImage {

  convenience init?(podResourceNamed name: String) {
    let bundleUrl =
      NSBundle(forClass: MobilePlayerViewController.self).URLForResource("MobilePlayer", withExtension: "bundle") ??
      NSBundle(forClass: MobilePlayerViewController.self).bundleURL
    let bundle = NSBundle(URL: bundleUrl)
    self.init(named: name, inBundle: bundle, compatibleWithTraitCollection:nil)
  }

  var template: UIImage {
    return imageWithRenderingMode(.AlwaysTemplate)
  }
}
