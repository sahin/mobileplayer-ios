//
//  ToggleButton.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/16/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import SnapKit

class ToggleButton: UIButton {
  let config: ToggleButtonConfig
  var toggled = false { didSet { update() } }

  init(config: ToggleButtonConfig = ToggleButtonConfig()) {
    self.config = config
    super.init(frame: CGRectZero)
    tintColor = config.tintColor
    setImage(config.image, forState: .Normal)
    snp_makeConstraints { make in
      make.width.equalTo(config.width)
      make.height.equalTo(config.height)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func update() {
    if toggled {
      tintColor = config.toggledTintColor
      setImage(config.toggledImage, forState: .Normal)
    } else {
      tintColor = config.tintColor
      setImage(config.image, forState: .Normal)
    }
  }
}
