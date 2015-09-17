//
//  Button.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/16/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

class Button: UIButton {
  let config: ButtonConfig

  init(config: ButtonConfig = ButtonConfig()) {
    self.config = config
    super.init(frame: CGRectZero)
    tintColor = config.tintColor
    setBackgroundImage(config.image, forState: .Normal)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func sizeThatFits(size: CGSize) -> CGSize {
    return CGSize(width: config.width, height: config.height)
  }
}
