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
  let videoURL = NSURL(string: "https://r9---sn-o097znle.googlevideo.com/videoplayback?ratebypass=yes&mn=sn-o097znle&lmt=1393770953929508&dur=282.099&mt=1448416462&mm=31&expire=1448438136&id=o-AINSj_idGI22mdpoOSomuR9LIws1wtA_QXXlvX9tULpD&ipbits=0&pl=17&mv=m&ms=au&ip=50.174.242.202&sver=3&signature=83EDF5A9CE6A2F74E638C12A22CA745F14BB87A2.79967314D6CD9DBE276A7E719F3CC65771E7557F&sparams=dur%2Cgcr%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cnh%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cupn%2Cexpire&itag=22&source=youtube&upn=oFNrCno98mg&nh=IgpwcjAyLnNqYzA3KgkxMjcuMC4wLjE&mime=video%2Fmp4&key=yt6&fexp=9408710%2C9416126%2C9417683%2C9420452%2C9421017%2C9422596%2C9422618%2C9423662&initcwndbps=832500&requiressl=yes&gcr=us")!

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
