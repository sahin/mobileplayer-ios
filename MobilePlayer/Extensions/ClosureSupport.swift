//
//  ClosureSupport.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/10/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

class CallbackContainer {
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
    let callbackContainer = CallbackContainer(callback: callback)
    return scheduledTimerWithTimeInterval(
      ti,
      target: callbackContainer,
      selector: "callCallback",
      userInfo: nil,
      repeats: repeats)
  }
}

extension UIControl {

  func addCallback(callback: () -> Void, forControlEvents controlEvents: UIControlEvents) -> UnsafePointer<Void> {
    let callbackContainer = CallbackContainer(callback: callback)
    let key = unsafeAddressOf(callbackContainer)
    objc_setAssociatedObject(self, key, callbackContainer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    addTarget(callbackContainer, action: "callCallback", forControlEvents: controlEvents)
    return key
  }

  func removeCallbackForKey(key: UnsafePointer<Void>) {
    if let callbackContainer = objc_getAssociatedObject(self, key) as? CallbackContainer {
      removeTarget(callbackContainer, action: "callCallback", forControlEvents: .AllEvents)
      objc_setAssociatedObject(self, key, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

extension UIGestureRecognizer {

  convenience init(callback: () -> Void) {
    let callbackContainer = CallbackContainer(callback: callback)
    self.init(target: callbackContainer, action: "callCallback")
    objc_setAssociatedObject(
      self,
      unsafeAddressOf(callbackContainer),
      callbackContainer,
      objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
}
