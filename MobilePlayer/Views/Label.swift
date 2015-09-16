//
//  Label.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/16/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

class Label: UILabel {
  let config: LabelConfig

  init(config: LabelConfig = LabelConfig()) {
    self.config = config
    super.init(frame: CGRectZero)
    text = config.text
    font = config.font
    textColor = config.textColor
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
