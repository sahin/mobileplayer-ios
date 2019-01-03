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

  override init() {
    super.init()
    title = "Remote Configuration"
    codeImageView.image = UIImage(named: "RemoteConfigExampleCode")
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func showButtonDidGetTapped() {
    guard let configURL = URL(string: "https://goo.gl/c73ANK") else { return }
    let playerVC = MobilePlayerViewController(
      contentURL: videoURL,
      config: MobilePlayerConfig(fileURL: configURL))
    playerVC.title = "Watermarked Player - \(videoTitle)"
    playerVC.activityItems = [videoURL]
    present(playerVC, animated: true, completion: nil)
  }
}
