//
//  CGRect+LayoutHelper.swift
//  MovielalaPlayer
//
//  Created by Baris Sencan on 17/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation

extension CGRect {
  var rectX: CGFloat { return self.origin.x }
  var rectY: CGFloat { return self.origin.y }
  var width: CGFloat { return self.size.width }
  var height: CGFloat { return self.size.height }
  var aspectRatio: CGFloat { return self.width / self.height }
}
