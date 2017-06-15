//
//  VolumeView.swift
//  MobilePlayer
//
//  Created by Toygar Dündaralp on 25/06/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MediaPlayer

private let defaultIncreaseVolumeTintColor = UIColor.black
private let defaultReduceVolumeTintColor = UIColor.black

//class VolumeView: UIView {
//  let volumeSlider = MPVolumeView(frame: CGRect(x: -22, y: 50, width: 110, height: 50))
//  let increaseVolumeImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
//  let reduceVolumeImage = UIImageView(frame: CGRect(x: 10, y: 130, width: 20, height: 20))
//
//  init(
//    increaseVolumeTintColor: UIColor = defaultIncreaseVolumeTintColor,
//    reduceVolumeTintColor: UIColor = defaultReduceVolumeTintColor) {
//      super.init(frame: .zero)
//      layer.cornerRadius = 5
//      layer.borderColor = UIColor.gray.cgColor
//      layer.borderWidth = 0.5
//      layer.masksToBounds = true
//      backgroundColor = UIColor.white
//      volumeSlider.transform = CGAffineTransform(rotationAngle: .pi / -2)
//      volumeSlider.showsRouteButton = false
//      addSubview(volumeSlider)
//      increaseVolumeImage.contentMode = .scaleAspectFit
//      increaseVolumeImage.image = UIImage(podResourceNamed: "MLIncreaseVolume")?.template
//      increaseVolumeImage.tintColor = increaseVolumeTintColor
//      addSubview(increaseVolumeImage)
//      reduceVolumeImage.contentMode = .scaleAspectFit
//      reduceVolumeImage.image = UIImage(podResourceNamed: "MLReduceVolume")?.template
//      reduceVolumeImage.tintColor = reduceVolumeTintColor
//      addSubview(reduceVolumeImage)
//  }
//
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//    
//    
//}

class VolumeView: UIButton {
    let config: VolumeConfig
    
    init(config: VolumeConfig = VolumeConfig()) {
        self.config = config
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.setImage(UIImage(named: "AirPlayBtn"), for: UIControlState.normal)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Element
extension VolumeView: Element {
    var type: ElementType { return config.type }
    var identifier: String? { return config.identifier }
    var widthCalculation: ElementWidthCalculation { return config.widthCalculation }
    var width: CGFloat { return config.width }
    var marginLeft: CGFloat { return config.marginLeft }
    var marginRight: CGFloat { return config.marginRight }
    var view: UIView { return self }
}

class VolumeViewAirPlay: MPVolumeView {
    let config: VolumeConfig
    
    init(config: VolumeConfig = VolumeConfig()) {
        self.config = config
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.showsVolumeSlider = false
        self.setRouteButtonImage(UIImage(named: "AirPlayBtn"), for: UIControlState.normal)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Element
extension VolumeViewAirPlay: Element {
    var type: ElementType { return config.type }
    var identifier: String? { return config.identifier }
    var widthCalculation: ElementWidthCalculation { return config.widthCalculation }
    var width: CGFloat { return config.width }
    var marginLeft: CGFloat { return config.marginLeft }
    var marginRight: CGFloat { return config.marginRight }
    var view: UIView { return self }
}

public class VolumeConfig: ElementConfig {
    
    /// Button image.
//    public let image: UIImage?
    
    
    /// Initializes using default values.
    public convenience init() {
        self.init(dictionary: [String: Any]())
    }
    
    /// Initializes using a dictionary.
    ///
    /// * Key for `height` is `"height"` and its value should be a number.
    /// * Key for `image` is `"image"` and its value should be an image asset name.
    /// * Key for `tintColor` is `"tintColor"` and its value should be a color hex string.
    ///
    /// - parameters:
    ///   - dictionary: Button configuration dictionary.
    public override init(dictionary: [String: Any]) {        
        super.init(dictionary: dictionary)
    }
}
