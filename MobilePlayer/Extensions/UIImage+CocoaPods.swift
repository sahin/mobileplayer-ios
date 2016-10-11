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
      Bundle(for: MobilePlayerViewController.self).url(forResource: "MobilePlayer", withExtension: "bundle") ??
      Bundle(for: MobilePlayerViewController.self).bundleURL
    let bundle = Bundle(url: bundleUrl)
    self.init(named: name, in: bundle, compatibleWith: nil)
  }

  var template: UIImage {
    return withRenderingMode(.alwaysTemplate)
  }
}
