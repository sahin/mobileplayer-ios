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

extension Timer {

  class func scheduledTimerWithTimeInterval(_ ti: TimeInterval, callback: () -> Void, repeats: Bool) -> Timer {
    let callbackContainer = CallbackContainer(callback: callback)
    return scheduledTimer(
      timeInterval: ti,
      target: callbackContainer,
      selector: #selector(CallbackContainer.callCallback),
      userInfo: nil,
      repeats: repeats)
  }
}

extension UIControl {

  func addCallback(_ callback: () -> Void, forControlEvents controlEvents: UIControlEvents) -> UnsafePointer<Void> {
    let callbackContainer = CallbackContainer(callback: callback)
    let key = unsafeAddress(of: callbackContainer)
    objc_setAssociatedObject(self, key, callbackContainer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    addTarget(callbackContainer, action: #selector(CallbackContainer.callCallback), for: controlEvents)
    return key
  }

  func removeCallbackForKey(_ key: UnsafePointer<Void>) {
    if let callbackContainer = objc_getAssociatedObject(self, key) as? CallbackContainer {
      removeTarget(callbackContainer, action: #selector(CallbackContainer.callCallback), for: .allEvents)
      objc_setAssociatedObject(self, key, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

extension UIGestureRecognizer {

  convenience init(callback: () -> Void) {
    let callbackContainer = CallbackContainer(callback: callback)
    self.init(target: callbackContainer, action: #selector(CallbackContainer.callCallback))
    objc_setAssociatedObject(
      self,
      unsafeAddress(of: callbackContainer),
      callbackContainer,
      objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
}
