//
//  ExampleViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 23/11/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {
  let codeImageView = UIImageView(frame: CGRect.zero)
  let videoURL = URL(string: "https://www.youtube.com/watch?v=sGbxmsDFVnE")!
  let videoTitle = "Star Wars: Episode VII - The Force Awakens - International Trailer"
  let videoID = "1"

  init() {
    super.init(nibName: nil, bundle: nil)
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Player", style: .plain, target: self, action: #selector(showButtonDidGetTapped))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1)
    view.addSubview(codeImageView)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let size = view.frame.size
    let top = topLayoutGuide.length
    codeImageView.sizeToFit()
    codeImageView.frame.origin.x = (size.width - codeImageView.frame.size.width) / 2
    codeImageView.frame.origin.y = top + (size.height - top - codeImageView.frame.size.height) / 2
  }

  @objc func showButtonDidGetTapped() {
    fatalError("showButtonDidGetTapped() has not been implemented")
  }
}
