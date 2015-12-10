//
//  PauseOverlayViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 09/12/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import Foundation
import MobilePlayer

class PauseOverlayViewController: MobilePlayerOverlayViewController {
  @IBOutlet weak var containerView: UIView!

  init() {
    super.init(nibName: "PauseOverlayViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    containerView.layer.cornerRadius = 6
  }
}
