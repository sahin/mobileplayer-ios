//
//  SocialSharing.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 7/9/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import Social

public class SocialSharing {

  public static
    func showSocialViewWithTitle(
    msg: String,
    image: UIImage?,
    url: NSURL?,
    viewController: UIViewController) {
      let settingsActionSheet: UIAlertController =
      UIAlertController(
        title: nil,
        message: nil,
        preferredStyle: UIAlertControllerStyle.ActionSheet)
      settingsActionSheet.addAction(UIAlertAction(
        title: "Twitter Share",
        style: UIAlertActionStyle.Default,
        handler:{ action in
          if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetSheet.setInitialText(msg)
            if let url = url as NSURL? {
              tweetSheet.addURL(url)
            }
            if let image = image as UIImage? {
              tweetSheet.addImage(image)
            }
            viewController.presentViewController(tweetSheet, animated: true, completion: nil)
          } else {
            let alert = UIAlertView()
            alert.title = "Twitter Share"
            alert.message = "Error, Check your account settings"
            alert.addButtonWithTitle("OK")
            alert.show()
          }
      }))
      settingsActionSheet.addAction(UIAlertAction(
        title: "Facebook Share",
        style:UIAlertActionStyle.Default,
        handler:{ action in
          if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let facebookSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText(msg)
            if let url = url as NSURL? {
              facebookSheet.addURL(url)
            }
            if let image = image as UIImage? {
              facebookSheet.addImage(image)
            }
            viewController.presentViewController(facebookSheet, animated: true, completion: nil)
          } else {
            let alert = UIAlertView()
            alert.title = "Facebook Share"
            alert.message = "Error, Check your account settings"
            alert.addButtonWithTitle("OK")
            alert.show()
          }
      }))
      settingsActionSheet.addAction(UIAlertAction(
        title: "Cancel",
        style: UIAlertActionStyle.Cancel,
        handler: nil))
      viewController.presentViewController(settingsActionSheet, animated:true, completion:nil)
  }
}
