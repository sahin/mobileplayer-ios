//
//  ProgConfigExampleViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 07/12/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MobilePlayer

class ProgConfigExampleViewController: ExampleViewController {

  override init() {
    super.init()
    title = "Programmatic Configuration"
    codeImageView.image = UIImage(named: "ProgConfigExampleCode")
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func showButtonDidGetTapped() {
    let playerVC = MobilePlayerViewController(
      contentURL: videoURL,
      config: MobilePlayerConfig(
        dictionary: ["watermark": ["image": "MovielalaLogo"]]))
    playerVC.title = "Watermarked Player - \(videoTitle)"
    playerVC.activityItems = [videoURL]
    present(playerVC, animated: true, completion: nil)
  }
}
