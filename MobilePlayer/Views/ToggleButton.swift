//
//  ToggleButton.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/16/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

class ToggleButton: UIButton {
  let config: ToggleButtonConfig
  var toggled = false { didSet { update() } }

  init(config: ToggleButtonConfig = ToggleButtonConfig()) {
    self.config = config
    super.init(frame: CGRectZero)
    tintColor = config.tintColor
    setImage(config.image, forState: .Normal)
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

  override func sizeThatFits(size: CGSize) -> CGSize {
    return CGSize(width: config.width, height: config.height)
  }
}

// MARK: - Element
extension ToggleButton: Element {
  var type: ElementType { return config.type }
  var identifier: String? { return config.identifier }
  var widthCalculation: ElementWidthCalculationMode { return config.widthCalculation }
  var width: CGFloat { return config.width }
  var marginLeft: CGFloat { return config.marginLeft }
  var marginRight: CGFloat { return config.marginRight }
  var view: UIView { return self }
}
