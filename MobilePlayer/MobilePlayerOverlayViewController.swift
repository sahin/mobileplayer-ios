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

public class MobilePlayerOverlayViewController: UIViewController {
  weak var delegate: MobilePlayerOverlayViewControllerDelegate?

  public func dismiss() {
    delegate?.dismissMobilePlayerOverlayViewController(self)
  }
}
