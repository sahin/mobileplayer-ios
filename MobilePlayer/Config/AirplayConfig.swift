//
//  AirplayConfig.swift
//  MobilePlayer
//
//  Created by Maca on 3/10/17.
//  Copyright © 2017 MovieLaLa. All rights reserved.
//

import UIKit

/// Holds button configuration values.
public class AirplayConfig: ElementConfig {
    
    /// Airplay background color
    public let backgroundColor: UIColor
    
    /// Airplay tint color. Default value is white.
    public let tintColor: UIColor
    
    /// Initializes using default values.
    public convenience init() {
        self.init(dictionary: [String: Any]())
    }
    
    /// Initializes using a dictionary.
    ///
    /// * Key for `backgroundColor` is `"backgroundColor"` and its value should be a color hex string.
    /// * Key for `tintColor` is `"tintColor"` and its value should be a color hex string.
    ///
    /// - parameters:
    ///   - dictionary: Button configuration dictionary.
    public override init(dictionary: [String: Any]) {
        // Values need to be AnyObject for type conversions to work correctly.
        let dictionary = dictionary as [String: AnyObject]
        
        if let backgroundColorHex = dictionary["backgroundColor"] as? String {
            backgroundColor = UIColor(hex: backgroundColorHex)
        } else {
            backgroundColor = UIColor.clear
        }
        
        if let tintColorHex = dictionary["tintColor"] as? String {
            tintColor = UIColor(hex: tintColorHex)
        } else {
            tintColor = UIColor.white
        }
        
        super.init(dictionary: dictionary)
    }
}
