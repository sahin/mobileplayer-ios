//
//  ElementConfig.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/17/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

/// Determines the type of an element.
public enum ElementType: String {

  /// Element type is unknown, it won't be added to the UI hierarchy.
  case Unknown = "unknown"

  /// Element is a label.
  case Label = "label"

  /// Element is a button.
  case Button = "button"

  /// Element is a button that can be toggled between two states. (e.g. Play/pause button)
  case ToggleButton = "toggleButton"

  /// Element is a slider.
  case Slider = "slider"
}

/// Determines how an element's width will be calculated.
public enum ElementWidthCalculation: String {

  /// Element width will always be as defined in its `width` property.
  case AsDefined = "asDefined"

  /// Element width will be adjusted to fit its contents.
  case Fit = "fit"

  /// Element width will be adjusted to fill the remaining horizontal space in its container.
  case Fill = "fill"
}

/// Holds basic element configuration values.
public class ElementConfig {

  /// Type of the element. Default value is `.Unknown`.
  public let type: ElementType

  /// Identifier of the element.
  ///
  /// * Special identifiers are:
  ///   * Labels
  ///     * "title"
  ///     * "currentTime"
  ///     * "remainingTime"
  ///     * "duration"
  ///   * Buttons
  ///     * "close"
  ///     * "action"
  ///   * Toggle Buttons
  ///     * "play"
  ///   * Sliders
  ///     * "playback"
  public let identifier: String?

  /// How the width of the element will be calculated. Default value is `.Fill` for title label and playback slider,
  /// `.Fit` for other labels, and `.AsDefined` for the rest.
  public let widthCalculation: ElementWidthCalculation

  /// Element width, effective only if `widthCalculation` is set to `.AsDefined`. Default value is `40`.
  public let width: CGFloat

  /// The horizontal space to the left of this element that will be left empty. Default value is `0`.
  public let marginLeft: CGFloat

  /// The horizontal space to the right of this element that will be left empty. Default value is `0`.
  public let marginRight: CGFloat

  /// Initializes using default values.
  public convenience init() {
    self.init(dictionary: [String: Any]())
  }

  /// Initializes using a dictionary.
  ///
  /// * Key for `type` is `"type"` and its value should be a raw `ElementType` enum value.
  /// * Key for `identifier` is `"identifier"` and its value should be a string.
  /// * Key for `widthCalculation` is `"widthCalculation"` and its value should be a raw `ElementWidthCalculation` enum
  /// value.
  /// * Key for `width` is `"width"` and its value should be a number.
  /// * Key for `marginLeft` is `"marginLeft"` and its value should be a number.
  /// * Key for `marginRight` is `"marginRight"` and its value should be a number.
  ///
  /// - parameters:
  ///   - dictionary: Element configuration dictionary.
  public init(dictionary: [String: Any]) {
    // Values need to be AnyObject for type conversions to work correctly.
    let dictionary = dictionary as [String: AnyObject]
    
    if
      let elementTypeString = dictionary["type"] as? String,
      let elementType = ElementType(rawValue: elementTypeString) {
        type = elementType
    } else {
      type = .Unknown
    }

    let id = dictionary["identifier"] as? String
    self.identifier = id

    let isTitleLabel = (type == .Label && id == "title")
    let isPlaybackSlider = (type == .Slider && id == "playback")
    if
      let elementWidthCalculationString = dictionary["widthCalculation"] as? String,
      let elementWidthCalculation = ElementWidthCalculation(rawValue: elementWidthCalculationString) {
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
