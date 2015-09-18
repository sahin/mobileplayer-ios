//
//  Bar.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/16/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

class Bar: UIView {
  let config: BarConfig
  let gradientLayer: CAGradientLayer?
  let topBorderView = UIView(frame: CGRectZero)
  let bottomBorderView = UIView(frame: CGRectZero)
  let elements = [UIView]()

  init(config: BarConfig = BarConfig()) {
    self.config = config
    super.init(frame: CGRectZero)
    if config.backgroundColor.count == 1 {
      backgroundColor = config.backgroundColor[0]
    } else {
      let gradientLayer = CAGradientLayer()
      gradientLayer.colors = [config.backgroundColor.first!.CGColor, config.backgroundColor.last!.CGColor]
      gradientLayer.locations = [0, 1]
      layer.addSublayer(gradientLayer)
      self.gradientLayer = gradientLayer
    }
    topBorderView.backgroundColor = config.topBorderColor
    addSubview(topBorderView)
    bottomBorderView.backgroundColor = config.bottomBorderColor
    addSubview(bottomBorderView)
    for elementConfig in config.elements {
      guard let type = elementConfig.type else { continue }
      let element: UIView?
      // TODO: Define element types as an enum.
      switch type {
      case "button":
        guard let buttonConfig = elementConfig as? ButtonConfig else { continue }
        element = Button(config: buttonConfig)
      case "toggleButton":
        guard let toggleButtonConfig = elementConfig as? ToggleButtonConfig else { continue }
        element = ToggleButton(config: toggleButtonConfig)
      case "label":
        guard let labelConfig = elementConfig as? LabelConfig else { continue }
        element = Label(config: labelConfig)
      case "slider":
        guard let sliderConfig = elementConfig as? SliderConfig else { continue }
        element = Slider(config: sliderConfig)
      default:
        element = nil
      }
      if let element = element {
        addSubview(element)
        elements.append(element)
      }
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func getViewForElementWithIdentifier(identifier: String) -> UIView? {
    for view in subviews {
      guard let element = view as? Element else { continue }
      if element.config.identifier == identifier {
        return view
      }
    }
    return nil
  }

  override func sizeThatFits(size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: config.height + config.bottomBorderHeight + config.topBorderHeight)
  }

  override func layoutSubviews() {
    let size = bounds.size

    if let gradientLayer = gradientLayer {
      gradientLayer.frame = bounds
    }

    topBorderView.frame = CGRect(x: 0, y: 0, width: size.width, height: config.topBorderHeight)
    bottomBorderView.frame = CGRect(
      x: 0,
      y: size.height - config.bottomBorderHeight,
      width: size.width,
      height: config.bottomBorderHeight)

    // Size elements.
    var slidersWithUndefinedWidth = [Slider]()
    var totalOccupiedWidth = CGFloat(0)
    for element in elements {
      guard let config = (element as? Element)?.config else { continue }
      guard let type = config.type else { continue }
      switch type {
      case "button", "toggleButton", "label":
        element.sizeToFit()
        totalOccupiedWidth += element.frame.size.width
      case "slider":
        element.sizeToFit()
        guard let slider = element as? Slider else { continue }
        if slider.config.width == nil {
          slidersWithUndefinedWidth.append(slider)
        } else {
          totalOccupiedWidth += element.frame.size.width
        }
      default:
        break
      }
      totalOccupiedWidth += config.marginLeft + config.marginRight
    }

    if slidersWithUndefinedWidth.count > 0 {
      let widthPerSlider = (size.width - totalOccupiedWidth) / CGFloat(slidersWithUndefinedWidth.count)
      for slider in slidersWithUndefinedWidth {
        slider.frame.size.width = widthPerSlider
      }
    }

    // Position them.
    var left = CGFloat(0)
    for element in elements {
      guard let config = (element as? Element)?.config else { continue }
      left += config.marginLeft
      element.frame.origin = CGPoint(x: left, y: (size.height - element.frame.size.height) / 2)
      left += element.frame.size.width + config.marginRight
    }
  }
}
