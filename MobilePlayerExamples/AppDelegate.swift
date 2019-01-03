//
//  AppDelegate.swift
//  MobilePlayerExamples
//
//  Created by Baris Sencan on 23/11/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = UIColor.white
    window.rootViewController = UINavigationController(rootViewController: ExamplesTableViewController())
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}
