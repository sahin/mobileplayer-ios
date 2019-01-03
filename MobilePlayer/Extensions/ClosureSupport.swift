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

  init(callback: @escaping () -> Void) {
    self.callback = callback
  }

  @objc func callCallback() {
    callback()
  }
}

extension Timer {

  class func scheduledTimerWithTimeInterval(ti: TimeInterval, callback: @escaping () -> Void, repeats: Bool) -> Timer {
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

  @discardableResult
  func addCallback(callback: @escaping () -> Void, forControlEvents controlEvents: UIControl.Event) -> UnsafeMutableRawPointer {
    let callbackContainer = CallbackContainer(callback: callback)
    let key = Unmanaged.passUnretained(callbackContainer).toOpaque()
    objc_setAssociatedObject(self, key, callbackContainer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    addTarget(callbackContainer, action: #selector(CallbackContainer.callCallback), for: controlEvents)
    return key
  }

  func removeCallbackForKey(key: UnsafeRawPointer) {
    if let callbackContainer = objc_getAssociatedObject(self, key) as? CallbackContainer {
      removeTarget(callbackContainer, action: #selector(CallbackContainer.callCallback), for: .allEvents)
      objc_setAssociatedObject(self, key, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

extension UIGestureRecognizer {

  convenience init(callback: @escaping () -> Void) {
    let callbackContainer = CallbackContainer(callback: callback)
    self.init(target: callbackContainer, action: #selector(CallbackContainer.callCallback))
    objc_setAssociatedObject(
      self,
      Unmanaged.passUnretained(callbackContainer).toOpaque(),
      callbackContainer,
      objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
}
