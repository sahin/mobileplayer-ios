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
  let topBorderView = UIView(frame: .zero)
  let bottomBorderView = UIView(frame: .zero)
  var elements = [Element]()
  private var elementFindCache = [String: UIView]()

  init(config: BarConfig = BarConfig()) {
    self.config = config
    if config.backgroundColor.count > 1 {
      let gradientLayer = CAGradientLayer()
      gradientLayer.colors = [config.backgroundColor.first!.cgColor, config.backgroundColor.last!.cgColor]
      gradientLayer.locations = [0, 1]
      self.gradientLayer = gradientLayer
    } else {
      gradientLayer = nil
    }
    super.init(frame: .zero)
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
      addElement(usingConfig: elementConfig)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addElement(usingConfig config: ElementConfig) {
    let elementView: UIView?
    switch config.type {
    case .Button:
      guard let buttonConfig = config as? ButtonConfig else { return }
      elementView = Button(config: buttonConfig)
    case .ToggleButton:
      guard let toggleButtonConfig = config as? ToggleButtonConfig else { return }
      elementView = ToggleButton(config: toggleButtonConfig)
    case .Label:
      guard let labelConfig = config as? LabelConfig else { return }
      elementView = Label(config: labelConfig)
    case .Slider:
      guard let sliderConfig = config as? SliderConfig else { return }
      elementView = Slider(config: sliderConfig)
    case .Unknown:
      elementView = nil
    }
    if
      let elementView = elementView,
      let element = elementView as? Element {
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

  override func sizeThatFits(_ size: CGSize) -> CGSize {
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
    var viewsToFillAvailableWidth = [UIView]()
    var totalOccupiedWidth = CGFloat(0)
    for element in elements {
      element.view.sizeToFit()
      switch element.widthCalculation {
      case .AsDefined, .Fit:
        totalOccupiedWidth += element.view.frame.size.width
      case .Fill:
        viewsToFillAvailableWidth.append(element.view)
      }
      totalOccupiedWidth += element.marginLeft + element.marginRight
    }

    if viewsToFillAvailableWidth.count > 0 {
      let widthPerFillerView = (size.width - totalOccupiedWidth) / CGFloat(viewsToFillAvailableWidth.count)
      for view in viewsToFillAvailableWidth {
        view.frame.size.width = widthPerFillerView
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
