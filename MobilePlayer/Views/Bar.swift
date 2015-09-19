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
  var elements = [Element]()
  private var elementFindCache = [String: UIView]()

  init(config: BarConfig = BarConfig()) {
    self.config = config
    if config.backgroundColor.count > 1 {
      let gradientLayer = CAGradientLayer()
      gradientLayer.colors = [config.backgroundColor.first!.CGColor, config.backgroundColor.last!.CGColor]
      gradientLayer.locations = [0, 1]
      self.gradientLayer = gradientLayer
    } else {
      gradientLayer = nil
    }
    super.init(frame: CGRectZero)
    if config.backgroundColor.count == 1 {
      backgroundColor = config.backgroundColor[0]
    } else if let gradientLayer = gradientLayer {
      layer.addSublayer(gradientLayer)
    }
    topBorderView.backgroundColor = config.topBorderColor
    addSubview(topBorderView)
    bottomBorderView.backgroundColor = config.bottomBorderColor
    addSubview(bottomBorderView)
    for elementConfig in config.elements {
      addElementUsingConfig(elementConfig)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addElementUsingConfig(config: ElementConfig) {
    guard let type = config.type else { return }
    let elementView: UIView?
    // TODO: Define element types as an enum.
    switch type {
    case "button":
      guard let buttonConfig = config as? ButtonConfig else { return }
      elementView = Button(config: buttonConfig)
    case "toggleButton":
      guard let toggleButtonConfig = config as? ToggleButtonConfig else { return }
      elementView = ToggleButton(config: toggleButtonConfig)
    case "label":
      guard let labelConfig = config as? LabelConfig else { return }
      elementView = Label(config: labelConfig)
    case "slider":
      guard let sliderConfig = config as? SliderConfig else { return }
      elementView = Slider(config: sliderConfig)
    default:
      elementView = nil
    }
    if let
      elementView = elementView,
      element = elementView as? Element {
        addSubview(elementView)
        elements.append(element)
        setNeedsLayout()
    }
  }

  func getViewForElementWithIdentifier(identifier: String) -> UIView? {
    if let view = elementFindCache[identifier] {
      return view
    }
    for element in elements {
      if element.identifier == identifier {
        elementFindCache[identifier] = element.view
        return element.view
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

    // Size element views.
    var slidersWithUndefinedWidth = [Slider]()
    var totalOccupiedWidth = CGFloat(0)
    for element in elements {
      guard let type = element.type else { continue }
      switch type {
      case "button", "toggleButton", "label":
        element.view.sizeToFit()
        totalOccupiedWidth += element.view.frame.size.width
      case "slider":
        element.view.sizeToFit()
        guard let slider = element.view as? Slider else { continue }
        if slider.config.width == nil {
          slidersWithUndefinedWidth.append(slider)
        } else {
          totalOccupiedWidth += slider.frame.size.width
        }
      default:
        break
      }
      totalOccupiedWidth += element.marginLeft + element.marginRight
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
      left += element.marginLeft
      element.view.frame.origin = CGPoint(x: left, y: (size.height - element.view.frame.size.height) / 2)
      left += element.view.frame.size.width + element.marginRight
    }
  }
}
