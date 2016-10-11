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
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return examples.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
    cell.textLabel?.text = examples[(indexPath as NSIndexPath).row].title
    cell.accessoryType = .disclosureIndicator
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    show(examples[(indexPath as NSIndexPath).row], sender: self)
  }
}
