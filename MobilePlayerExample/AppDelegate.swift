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
      let playerController = PlayerViewController()
      self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
      self.window!.rootViewController = playerController
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
