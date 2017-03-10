//
//  Airplay.swift
//  MobilePlayer
//
//  Created by Maca on 3/10/17.
//  Copyright © 2017 MovieLaLa. All rights reserved.
//

import UIKit
import MediaPlayer

class Airplay: MPVolumeView {
    let config: AirplayConfig
    
    init(config: AirplayConfig = AirplayConfig()) {
        self.config = config
        super.init(frame: .zero)
        accessibilityLabel = accessibilityLabel ?? config.identifier
        tintColor = config.tintColor
        backgroundColor = config.backgroundColor
        showsRouteButton = true
        showsVolumeSlider = false
        translatesAutoresizingMaskIntoConstraints = false
        self.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        let superSize = super.sizeThatFits(size)
//        return CGSize(
//            width: 40.0,
//            height: superSize.height)
//    }
}

// MARK: - Element
extension Airplay: Element {
    var type: ElementType { return config.type }
    var identifier: String? { return config.identifier }
    var widthCalculation: ElementWidthCalculation { return config.widthCalculation }
    var width: CGFloat { return config.width }
    var marginLeft: CGFloat { return config.marginLeft }
    var marginRight: CGFloat { return config.marginRight }
    var view: UIView { return self }
}
