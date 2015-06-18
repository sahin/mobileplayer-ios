//
//  AppDelegate.swift
//  MobilePlayerExample
//
//  Created by Toygar Dündaralp on 14/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MediaPlayer
import MobilePlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      if let fileUrl = NSBundle.mainBundle().URLForResource("BarbieSkin", withExtension: "json") {
        let youtubeURL = NSURL(string: "https://www.youtube.com/watch?v=Kznek1uNVsg")!
        let youtubeLiveURL = NSURL(string: "https://www.youtube.com/watch?v=rxGoGg7n77A")!
        let playerVC = MobilePlayerViewController(
          youTubeURL: youtubeURL,
          configFileURL: fileUrl
        )
        let banner: ADBannerViewController = ADBannerViewController()
        playerVC.overlayController = banner
        playerVC.overlayTimeValues = ["start": 2, "duration": 6]
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = playerVC
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
      } else {
        println("MobilePlayer: Skin file not found")
      }
      return true
  }

  func applicationWillResignActive(application: UIApplication) { }

  func applicationDidEnterBackground(application: UIApplication) { }

  func applicationWillEnterForeground(application: UIApplication) { }

  func applicationDidBecomeActive(application: UIApplication) { }

  func applicationWillTerminate(application: UIApplication) { }
}
