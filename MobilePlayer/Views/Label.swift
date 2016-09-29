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
    super.init(frame: .zero)
    accessibilityLabel = accessibilityLabel ?? config.identifier
    text = config.text
    font = config.font
    textColor = config.textColor
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let superSize = super.sizeThatFits(size)
    switch config.widthCalculation {
    case .AsDefined:
      return CGSize(width: config.width, height: superSize.height)
    default:
      return superSize
    }
  }
}

// MARK: - Element
extension Label: Element {
  var type: ElementType { return config.type }
  var identifier: String? { return config.identifier }
  var widthCalculation: ElementWidthCalculation { return config.widthCalculation }
  var width: CGFloat { return config.width }
  var marginLeft: CGFloat { return config.marginLeft }
  var marginRight: CGFloat { return config.marginRight }
  var view: UIView { return self }
}
