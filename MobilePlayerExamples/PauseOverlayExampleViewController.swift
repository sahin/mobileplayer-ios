//
//  PauseOverlayExampleViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 09/12/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import Foundation
import MobilePlayer

class PauseOverlayExampleViewController: ExampleViewController {

  override init() {
    super.init()
    title = "Showing a Pause Overlay"
    codeImageView.image = UIImage(named: "PauseOverlayExampleCode")
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func showButtonDidGetTapped() {
    let playerVC = MobilePlayerViewController(
      contentURL: videoURL,
      pauseOverlayViewController: PauseOverlayViewController())
    playerVC.title = videoTitle
    playerVC.activityItems = [videoURL]
    presentMoviePlayerViewControllerAnimated(playerVC)
  }
}
