//
//  ExampleViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 23/11/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {
  let codeImageView = UIImageView(frame: CGRectZero)
  let showButton = UIButton(type: .System)
  let videoURL = NSURL(string: "https://movielalavideos.blob.core.windows.net/videos/563cb51788b8c6db4b000376.mp4")!
  let videoTitle = "Star Wars: Episode VII - The Force Awakens - International Trailer"

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.whiteColor()
    view.addSubview(codeImageView)
    showButton.setTitle("Show Player", forState: .Normal)
    showButton.addTarget(self, action: "showButtonDidGetTapped", forControlEvents: .TouchUpInside)
    view.addSubview(showButton)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let size = view.frame.size;
    codeImageView.sizeToFit()
    codeImageView.frame.origin.x = (size.width - codeImageView.frame.size.width) / 2
    codeImageView.frame.origin.y = (size.height - codeImageView.frame.size.height) / 2
    showButton.sizeToFit()
    codeImageView.frame.origin.y -= (showButton.frame.size.height + 8) / 2;
    showButton.frame.origin.x = (size.width - showButton.frame.size.width) / 2
    showButton.frame.origin.y = codeImageView.frame.origin.y + codeImageView.frame.size.height + 8
  }

  func showButtonDidGetTapped() {
    fatalError("showButtonDidGetTapped() has not been implemented")
  }
}
