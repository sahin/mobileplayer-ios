//
//  MPSkinParser.swift
//  MovielalaPlayer
//
//  Created by Toygar Dündaralp on 14/05/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

public class MPSkinParser {
  
  public init() { }
  
  public func jsonResponse(FileName fName:String, ExtensionName eName:String) -> [String] {
    
    let filePath = NSBundle.mainBundle().pathForResource(fName,ofType:eName)
    var readError:NSError?
    if let data = NSData(contentsOfFile:filePath!, options:NSDataReadingOptions.DataReadingUncached, error:&readError) {
      let stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
      return ["\(stringData)"]
    }else{
      return [""]
    }
    
  }
  
}
