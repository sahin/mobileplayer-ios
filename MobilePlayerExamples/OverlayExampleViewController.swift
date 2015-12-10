//
//  OverlayExampleViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 08/12/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import Foundation
import MobilePlayer
import MobilePlayerExampleStores

class OverlayExampleViewController: ExampleViewController {
  
  override init() {
    super.init()
    title = "Showing Overlays"
    codeImageView.image = UIImage(named: "OverlayExampleCode")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func showButtonDidGetTapped() {
    let playerVC = MobilePlayerViewController(contentURL: videoURL)
    playerVC.title = videoTitle
    playerVC.activityItems = [videoURL]
    presentMoviePlayerViewControllerAnimated(playerVC)
    ProductStore.getProduct("1", success: { product in
      guard let product = product else { return }
      playerVC.showOverlayViewController(
        BuyOverlayViewController(product: product))
    })
  }
}
