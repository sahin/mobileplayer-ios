//
//  RemoteConfigExampleViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 23/11/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MobilePlayer

class RemoteConfigExampleViewController: ExampleViewController {

  init() {
    super.init(nibName: nil, bundle: nil)
    title = "Remote Configuration"
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func showButtonDidGetTapped() {
    // TODO
    let config = MobilePlayerConfig(fileURL: NSURL(string: "")!)
    let playerVC = MobilePlayerViewController(contentURL: videoURL, config: config)
    playerVC.title = "Remote Player - \(videoTitle)"
    playerVC.activityItems = [videoURL]
    presentMoviePlayerViewControllerAnimated(playerVC)
  }
}
