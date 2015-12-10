//
//  ExamplesTableViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 23/11/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import UIKit

class ExamplesTableViewController: UITableViewController {
  private let cellReuseIdentifier = "exampleCell"
  private let examples = [
    PlainExampleViewController(),
    ConfigExampleViewController(),
    RemoteConfigExampleViewController(),
    ProgConfigExampleViewController(),
    AdvancedConfigExampleViewController(),
    OverlayExampleViewController(),
    TimedOverlayExampleViewController(),
    PrerollExampleViewController(),
    PauseOverlayExampleViewController(),
    PostrollExampleViewController()
  ]
  
  init() {
    super.init(nibName: nil, bundle: nil)
    title = "MobilePlayer Examples"
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return examples.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
    cell.textLabel?.text = examples[indexPath.row].title
    cell.accessoryType = .DisclosureIndicator
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    showViewController(examples[indexPath.row], sender: self)
  }
}
