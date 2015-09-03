//
//  SkinListViewController.swift
//  MobilePlayer
//
//  Created by Toygar Dundaralp on 9/2/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

class SkinListViewController: UITableViewController {

  let arrSkins = [
    "Youtube Style",
    "Hulu Style",
    "Netflix Style",
    "Facebook Style",
    "Super Minimalist",
    "Slim"]
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Select Your Skin"
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: - Table view data source
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrSkins.count
  }

  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .Default, reuseIdentifier: "CellIdentifier")
    cell.textLabel!.text = arrSkins[indexPath.row]
    return cell
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var skinName = "Minimal"
    switch indexPath.row {
    case 0:
      skinName = "Youtube"
    case 1:
      skinName = "Hulu"
    case 2:
      skinName = "Netflix"
    case 3:
      skinName = "Facebook"
    case 4:
      skinName = "Super Minimalist"
    case 5:
      skinName = "Slim"
    default:
      break
    }
    let skinFile = NSBundle.mainBundle().URLForResource(skinName, withExtension: "json")!
    let playerVC = PlayerViewController(skinFile: skinFile)
    self.presentViewController(playerVC, animated: true) { () -> Void in }
  }
}
