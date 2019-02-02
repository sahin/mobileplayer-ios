//
//  PostrollExampleViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 09/12/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import Foundation
import MobilePlayer

class PostrollExampleViewController: ExampleViewController {

  override init() {
    super.init()
    title = "Showing a Post-roll"
    codeImageView.image = UIImage(named: "PostrollExampleCode")
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func showButtonDidGetTapped() {
    let playerVC = MobilePlayerViewController(
      contentURL: videoURL,
      postrollViewController: PostrollOverlayViewController())
    playerVC.title = videoTitle
    playerVC.activityItems = [videoURL]
    present(playerVC, animated: true, completion: nil)
  }
}
