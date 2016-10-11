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
    super.init(frame: .zero)
    accessibilityLabel = accessibilityLabel ?? config.identifier
    tintColor = config.tintColor
    setImage(config.image, for: .normal)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let superSize = super.sizeThatFits(size)
    return CGSize(
      width: (config.widthCalculation == .AsDefined) ? config.width : superSize.width,
      height: config.height)
  }
}

// MARK: - Element
extension Button: Element {
  var type: ElementType { return config.type }
  var identifier: String? { return config.identifier }
  var widthCalculation: ElementWidthCalculation { return config.widthCalculation }
  var width: CGFloat { return config.width }
  var marginLeft: CGFloat { return config.marginLeft }
  var marginRight: CGFloat { return config.marginRight }
  var view: UIView { return self }
}
