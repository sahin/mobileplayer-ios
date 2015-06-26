//
//  ADBannerViewController.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 18/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MobilePlayer

class ADBannerViewController: MobilePlayerOverlayViewController {

  private var bgColor = UIColor.clearColor()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = getRandomColor()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func getRandomColor() -> UIColor{
    return UIColor(
      red: CGFloat(drand48()),
      green: CGFloat(drand48()),
      blue: CGFloat(drand48()),
      alpha: 0.6)
  }
}
