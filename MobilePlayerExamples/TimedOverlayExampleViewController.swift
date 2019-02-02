//
//  TimedOverlayExampleViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 08/12/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import Foundation
import MobilePlayer
import MobilePlayerExampleStores

class TimedOverlayExampleViewController: ExampleViewController {

  override init() {
    super.init()
    title = "Showing Timed Overlays"
    codeImageView.image = UIImage(named: "TimedOverlayExampleCode")
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func showButtonDidGetTapped() {
    let playerVC = MobilePlayerViewController(contentURL: videoURL)
    playerVC.title = videoTitle
    playerVC.activityItems = [videoURL]
    present(playerVC, animated: true, completion: nil)
    ProductStore.getProductPlacementsForVideo(
      videoID,
      success: { productPlacements in
        guard let productPlacements = productPlacements else { return }
        for placement in productPlacements {
          ProductStore.getProduct(placement.productID, success: { product in
            guard let product = product else { return }
            playerVC.showOverlayViewController(
              BuyOverlayViewController(product: product),
              startingAtTime: placement.startTime,
              forDuration: placement.duration)
          })
        }
    })
  }
}
