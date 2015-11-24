//
//  ExampleViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 23/11/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {
  let showButton = UIButton(type: .System)

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.whiteColor()
    showButton.setTitle("Show Player", forState: .Normal)
    showButton.addTarget(self, action: "showButtonDidGetTapped", forControlEvents: .TouchUpInside)
    view.addSubview(showButton)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    showButton.sizeToFit()
    showButton.frame.origin.x = (view.frame.size.width - showButton.frame.size.width) / 2
    showButton.frame.origin.y = (view.frame.size.height - showButton.frame.size.height) / 2
  }

  func showButtonDidGetTapped() {
    print("not implemented")
  }
}
