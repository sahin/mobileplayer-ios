//
//  AdvancedConfigExampleViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 07/12/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MobilePlayer

class AdvancedConfigExampleViewController: ExampleViewController {

  override init() {
    super.init()
    title = "Advanced Configuration"
    codeImageView.image = UIImage(named: "AdvancedConfigExampleCode")
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func showButtonDidGetTapped() {
    let bundle = Bundle.main
    let config = MobilePlayerConfig(fileURL: bundle.url(
        forResource: "MovielalaPlayer",
      withExtension: "json")!)
    let playerVC = MobilePlayerViewController(
      contentURL: videoURL,
      config: config)
    playerVC.title = videoTitle
    playerVC.activityItems = [videoURL]
    present(playerVC, animated: true, completion: nil)
  }
}
