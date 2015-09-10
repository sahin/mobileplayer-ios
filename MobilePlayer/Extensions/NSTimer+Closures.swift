//
//  NSTimer+Closures.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/10/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

private class NSTimerCallbackContainer {
  let callback: () -> Void

  init(callback: () -> Void) {
    self.callback = callback
  }

  @objc func callCallback() {
    callback()
  }
}

extension NSTimer {

  class func scheduledTimerWithTimeInterval(ti: NSTimeInterval, callback: () -> Void, repeats: Bool) -> NSTimer {
    let callbackContainer = NSTimerCallbackContainer(callback: callback)
    return scheduledTimerWithTimeInterval(
      ti,
      target: callbackContainer,
      selector: "callCallback",
      userInfo: nil,
      repeats: repeats)
  }
}
