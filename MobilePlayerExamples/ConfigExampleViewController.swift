//
//  ConfigExampleViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 23/11/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MobilePlayer

class ConfigExampleViewController: ExampleViewController {

  override init() {
    super.init()
    title = "Configuration"
    codeImageView.image = UIImage(named: "ConfigExampleCode")
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func showButtonDidGetTapped() {
    let bundle = NSBundle.mainBundle()
    let config = MobilePlayerConfig(fileURL: bundle.URLForResource(
      "WatermarkedPlayer",
      withExtension: "json")!)
    let playerVC = MobilePlayerViewController(
      contentURL: videoURL,
      config: config)
    playerVC.title = "Watermarked Player - \(videoTitle)"
    playerVC.activityItems = [videoURL]
    presentMoviePlayerViewControllerAnimated(playerVC)
  }
}
