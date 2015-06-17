//
//  AppDelegate.swift
//  MovielalaPlayerExample
//
//  Created by Toygar Dündaralp on 14/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MovielalaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

    if let fileUrl = NSBundle.mainBundle().URLForResource("BarbieSkin", withExtension: "json") {
      let playerVC = MovielalaPlayerViewController(
        contentURL: NSURL(string: "http://player.vimeo.com/external/129470313"
          + ".m3u8?p=high,standard,mobile&s=87cf536853be9d543e30f9e227285906")!,
        configFileURL: fileUrl
      )
      playerVC.title = "Jurrasic World"
      self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
      self.window!.rootViewController = playerVC
      self.window!.backgroundColor = UIColor.whiteColor()
      self.window!.makeKeyAndVisible()
    } else {
      println("MovielalaPlayer: Skin file not found")
    }

    return true
  }

  func applicationWillResignActive(application: UIApplication) { }

  func applicationDidEnterBackground(application: UIApplication) { }

  func applicationWillEnterForeground(application: UIApplication) { }

  func applicationDidBecomeActive(application: UIApplication) { }

  func applicationWillTerminate(application: UIApplication) { }
}
