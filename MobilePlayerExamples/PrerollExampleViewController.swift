//
//  PrerollExampleViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 09/12/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import Foundation
import MobilePlayer

class PrerollExampleViewController: ExampleViewController {

  override init() {
    super.init()
    title = "Showing a Pre-roll"
    codeImageView.image = UIImage(named: "PrerollExampleCode")
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func showButtonDidGetTapped() {
    let playerVC = MobilePlayerViewController(
      contentURL: videoURL,
      prerollViewController: PrerollOverlayViewController())
    playerVC.title = videoTitle
    playerVC.activityItems = [videoURL]
    presentMoviePlayerViewControllerAnimated(playerVC)
  }
}
