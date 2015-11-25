//
//  PlainExampleViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 23/11/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MobilePlayer

class PlainExampleViewController: ExampleViewController {

  init() {
    super.init(nibName: nil, bundle: nil)
    title = "Plain"
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func showButtonDidGetTapped() {
    let playerVC = MobilePlayerViewController(contentURL: videoURL)
    playerVC.title = "Planet Earth"
    playerVC.activityItems = [videoURL]
    presentMoviePlayerViewControllerAnimated(playerVC)
  }
}
