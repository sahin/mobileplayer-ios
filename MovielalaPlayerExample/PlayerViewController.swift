//
//  ViewController.swift
//  MovielalaPlayerExample
//
//  Created by Toygar Dündaralp on 14/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MovielalaPlayer

class PlayerViewController: MovielalaPlayerViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Terminator Genesis Trailer 2015"
    
    var skinFile:MPSkinParser = MPSkinParser()
    
    var data = skinFile.jsonResponse(FileName: "Skin", ExtensionName: "json")
    println("\(data).")
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

