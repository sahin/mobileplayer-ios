//
//  MobilePlayerOverlayViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

protocol MobilePlayerOverlayViewControllerDelegate: class {
  func dismissMobilePlayerOverlay(overlayVC: MobilePlayerOverlayViewController)
}

public class MobilePlayerOverlayViewController: UIViewController {
  weak var delegate: MobilePlayerOverlayViewControllerDelegate?

  public func dismiss() {
    delegate?.dismissMobilePlayerOverlay(self)
  }
}
