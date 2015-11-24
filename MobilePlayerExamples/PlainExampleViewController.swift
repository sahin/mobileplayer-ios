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
    let videoURL = NSURL(string: "https://www.youtube.com/watch?v=ZR95iii14l8")!
    presentMoviePlayerViewControllerAnimated(MobilePlayerViewController(contentURL: videoURL))
  }
}
