//
//  WatermarkViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/18/15.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit

class WatermarkViewController: MobilePlayerOverlayViewController {
  let config: WatermarkConfig
  let watermarkImageView = UIImageView(frame: .zero)

  init(config: WatermarkConfig) {
    self.config = config
    super.init(nibName: nil, bundle: nil)
    watermarkImageView.image = config.image
    view.addSubview(watermarkImageView)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let size = view.frame.size
    let watermarkSize = watermarkImageView.image?.size ?? .zero
    watermarkImageView.frame.size = watermarkSize
    switch config.position {
    case .Center:
      watermarkImageView.frame.origin.x = (size.width - watermarkSize.width) / 2
      watermarkImageView.frame.origin.y = (size.height - watermarkSize.height) / 2
    case .Top:
      watermarkImageView.frame.origin.x = (size.width - watermarkSize.width) / 2
      watermarkImageView.frame.origin.y = 8
    case .TopRight:
      watermarkImageView.frame.origin.x = size.width - watermarkSize.width - 8
      watermarkImageView.frame.origin.y = 8
    case .Right:
      watermarkImageView.frame.origin.x = size.width - watermarkSize.width - 8
      watermarkImageView.frame.origin.y = (size.height - watermarkSize.height) / 2
    case .BottomRight:
      watermarkImageView.frame.origin.x = size.width - watermarkSize.width - 8
      watermarkImageView.frame.origin.y = size.height - watermarkSize.height - 8
    case .Bottom:
      watermarkImageView.frame.origin.x = (size.width - watermarkSize.width) / 2
      watermarkImageView.frame.origin.y = size.height - watermarkSize.height - 8
    case .BottomLeft:
      watermarkImageView.frame.origin.x = 8
      watermarkImageView.frame.origin.y = size.height - watermarkSize.height - 8
    case .Left:
      watermarkImageView.frame.origin.x = 8
      watermarkImageView.frame.origin.y = (size.height - watermarkSize.height) / 2
    case .TopLeft:
      watermarkImageView.frame.origin.x = 8
      watermarkImageView.frame.origin.y = 8
    }
  }
}
