//
//  MovielalaPlayerOverlayViewController.swift
//  MovielalaPlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

protocol MovielalaPlayerOverlayViewControllerDelegate: class {
  func dismissMovielalaPlayerOverlay(overlayVC: MovielalaPlayerOverlayViewController)
}

public class MovielalaPlayerOverlayViewController: UIViewController {
  weak var delegate: MovielalaPlayerOverlayViewControllerDelegate?

  public func dismiss() {
    delegate?.dismissMovielalaPlayerOverlay(self)
  }
}
