//
//  AppDelegate.swift
//  MobilePlayerExample
//
//  Created by Toygar Dündaralp on 14/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MobilePlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let youtubeURL = NSURL(string: "https://www.youtube.com/watch?v=ZyIVaZXDhho")!
        let movieURL = NSURL(string: "http://goo.gl/97Dezi")!
        let youtubeStreamURL = NSURL(string: "https://www.youtube.com/watch?v=tlQV61zW2kU")!
        let skinFile = NSBundle.mainBundle().URLForResource("All", withExtension: "json")!
        let playerVC = MobilePlayerViewController(youTubeURL: youtubeURL, configFileURL: skinFile)
        /*
        playerVC.config.prerollViewController = PreRollViewController()
        playerVC.showOverlayViewController(
          ADBannerViewController(),
          startingAtTime: 3,
          forDuration: 3
        )
        playerVC.showOverlayViewController(
          ADBannerViewController(),
          startingAtTime: 10,
          forDuration: 5
        )
        */
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = playerVC
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()

      return true
  }

  func applicationWillResignActive(application: UIApplication) { }

  func applicationDidEnterBackground(application: UIApplication) { }

  func applicationWillEnterForeground(application: UIApplication) { }

  func applicationDidBecomeActive(application: UIApplication) { }

  func applicationWillTerminate(application: UIApplication) { }
}
