//
//  PlayerViewController.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 8/13/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MobilePlayer

class PlayerViewController: UIViewController, MobilePlayerViewControllerDelegate {

  let youtubeURL = NSURL(string: "https://www.youtube.com/watch?v=ZyIVaZXDhho")!
  let skinFile = NSBundle.mainBundle().URLForResource("Netflix", withExtension: "json")!

  override func viewDidLoad() {
    super.viewDidLoad()
    let playerVC = MobilePlayerViewController(youTubeURL: youtubeURL, configFileURL: skinFile)
    playerVC.view.frame = self.view.frame
    playerVC.delegate = self
    self.view.addSubview(playerVC.view)
    // playerVC.config.prerollViewController = PreRollViewController()
    // playerVC.showOverlayViewController(ADBannerViewController(), startingAtTime: 3, forDuration: 3)
    // playerVC.showOverlayViewController(ADBannerViewController(), startingAtTime: 10, forDuration: 5)
  }

  func didPressButton(button: UIButton, identifier: String) {
    UIAlertView(title: identifier, message: "Action", delegate: self, cancelButtonTitle: "OK").show()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
