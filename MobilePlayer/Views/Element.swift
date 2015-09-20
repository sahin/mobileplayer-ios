//
//  Element.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 9/17/15.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

protocol Element {
  var type: ElementType { get }
  var identifier: String? { get }
  var widthCalculation: ElementWidthCalculation { get }
  var width: CGFloat { get }
  var marginLeft: CGFloat { get }
  var marginRight: CGFloat { get }
  var view: UIView { get }
}
