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

public enum ElementWidthCalculation: String {
  case AsDefined = "asDefined"
  case Fit = "fit"
  case Fill = "fill"
}

public class ElementConfig {
  public let type: ElementType
  public let identifier: String?
  public let widthCalculation: ElementWidthCalculation
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

    let id = dictionary["identifier"] as? String
    self.identifier = id

    let isTitleLabel = (type == .Label && id == "title")
    let isPlaybackSlider = (type == .Slider && id == "playback")
    if let
      elementWidthCalculationString = dictionary["widthCalculation"] as? String,
      elementWidthCalculation = ElementWidthCalculation(rawValue: elementWidthCalculationString) {
        widthCalculation = elementWidthCalculation
    } else if isTitleLabel || isPlaybackSlider {
      widthCalculation = .Fill
    } else if type == .Label {
      widthCalculation = .Fit
    } else {
      widthCalculation = .AsDefined
    }

    width = (dictionary["width"] as? CGFloat) ?? 40
    marginLeft = (dictionary["marginLeft"] as? CGFloat) ?? 0
    marginRight = (dictionary["marginRight"] as? CGFloat) ?? 0
  }
}
