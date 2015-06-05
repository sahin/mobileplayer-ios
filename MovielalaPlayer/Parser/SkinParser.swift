//
//  MPSkinParser.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 14/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

public struct SkinParser {
  
  static func parseConfigFromURL(url: NSURL) -> MovielalaPlayerConfig? {
    if let
      jsonString = String(contentsOfURL: url, encoding: NSUTF8StringEncoding),
      jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding),
      dictionary = NSJSONSerialization.JSONObjectWithData(
        jsonData, options: nil, error: nil) as? [String: AnyObject] {
          return MovielalaPlayerConfig(dictionary: dictionary)
    } else {
      println("MovielalaPlayer: Skin File Error! - Please check json validation")
    }
    return nil
  }
}
