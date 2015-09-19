//
//  ElementConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/17/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

public enum ElementType: String {
  case Unknown = "unknown"
  case Label = "label"
  case Button = "button"
  case ToggleButton = "toggleButton"
  case Slider = "slider"
}

public enum ElementWidthCalculationMode: String {
  case AsDefined = "asDefined"
  case Fill = "fill"
  case Fit = "fit"
}

public class ElementConfig {
  public let type: ElementType
  public let identifier: String?
  public let widthCalculation: ElementWidthCalculationMode
  public let width: CGFloat
  public let marginLeft: CGFloat
  public let marginRight: CGFloat

  public convenience init() {
    self.init(dictionary: [String: AnyObject]())
  }

  public init(dictionary: [String: AnyObject]) {
    if let
      elementTypeString = dictionary["type"] as? String,
      elementType = ElementType(rawValue: elementTypeString) {
        type = elementType
    } else {
      type = .Unknown
    }

    identifier = dictionary["identifier"] as? String

    if let
      widthCalculationModeString = dictionary["widthCalculation"] as? String,
      widthCalculationMode = ElementWidthCalculationMode(rawValue: widthCalculationModeString) {
        widthCalculation = widthCalculationMode
    } else {
      widthCalculation = .AsDefined
    }

    width = (dictionary["width"] as? CGFloat) ?? 40
    marginLeft = (dictionary["marginLeft"] as? CGFloat) ?? 0
    marginRight = (dictionary["marginRight"] as? CGFloat) ?? 0
  }
}
