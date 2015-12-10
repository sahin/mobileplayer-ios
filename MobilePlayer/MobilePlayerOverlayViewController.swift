//
//  MobilePlayerOverlayViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

struct TimedOverlayInfo {
  let startTime: NSTimeInterval
  let duration: NSTimeInterval
  let overlay: MobilePlayerOverlayViewController
}

protocol MobilePlayerOverlayViewControllerDelegate: class {
  func dismissMobilePlayerOverlayViewController(overlayViewController: MobilePlayerOverlayViewController)
}

/// A view controller used for presenting views on top of player content. Meant to be subclassed.
public class MobilePlayerOverlayViewController: UIViewController {
  weak var delegate: MobilePlayerOverlayViewControllerDelegate?

  /// The MobilePlayerViewController instance that the overlay is being shown by.
  /// It's value is nil if the overlay is not being shown at the time this property is accessed.
  public var mobilePlayer: MobilePlayerViewController? {
    return delegate as? MobilePlayerViewController
  }

  /// Causes the view controller's view to be removed from on top of player content if it is being displayed.
  public func dismiss() {
    delegate?.dismissMobilePlayerOverlayViewController(self)
  }
}
