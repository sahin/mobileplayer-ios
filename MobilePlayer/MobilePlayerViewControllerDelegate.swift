//
//  MobilePlayerViewControllerDelegate.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 8/19/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit

public protocol MobilePlayerViewControllerDelegate: class {
   func didPressButton(button: UIButton, identifier: String)
}
