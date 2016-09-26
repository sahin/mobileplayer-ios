//
//  MobilePlayerControlsView.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MediaPlayer

final class MobilePlayerControlsView: UIView {
  let config: MobilePlayerConfig
  let previewImageView = UIImageView(frame: .zero)
  let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
  let overlayContainerView = UIView(frame: .zero)
  let topBar: Bar
  let bottomBar: Bar

  var controlsHidden: Bool = false {
    didSet {
      if oldValue != controlsHidden {
        UIView.animate(withDuration: 0.2) {
          self.layoutSubviews()
        }
      }
    }
  }

  init(config: MobilePlayerConfig) {
    self.config = config
    topBar = Bar(config: config.topBarConfig)
    bottomBar = Bar(config: config.bottomBarConfig)
    super.init(frame: .zero)
    previewImageView.contentMode = .scaleAspectFit
    addSubview(previewImageView)
    activityIndicatorView.startAnimating()
    addSubview(activityIndicatorView)
    addSubview(overlayContainerView)
    if topBar.elements.count == 0 {
      topBar.addElementUsingConfig(config: ButtonConfig(dictionary: ["type": "button" as AnyObject, "identifier": "close" as AnyObject]))
      topBar.addElementUsingConfig(config: LabelConfig(dictionary: ["type": "label" as AnyObject, "identifier": "title" as AnyObject]))
      topBar.addElementUsingConfig(config: ButtonConfig(dictionary: ["type": "button" as AnyObject, "identifier": "action" as AnyObject]))
    }
    addSubview(topBar)
    if bottomBar.elements.count == 0 {
      bottomBar.addElementUsingConfig(config: ToggleButtonConfig(dictionary: ["type": "toggleButton" as AnyObject, "identifier": "play" as AnyObject]))
      bottomBar.addElementUsingConfig(config: LabelConfig(dictionary: ["type": "label" as AnyObject, "identifier": "currentTime" as AnyObject]))
      bottomBar.addElementUsingConfig(config: SliderConfig(dictionary: ["type": "slider" as AnyObject, "identifier": "playback" as AnyObject, "marginLeft": 8 as AnyObject, "marginRight": 8 as AnyObject]))
      bottomBar.addElementUsingConfig(config: LabelConfig(dictionary: ["type": "label" as AnyObject, "identifier": "duration" as AnyObject, "marginRight": 8 as AnyObject]))
    }
    addSubview(bottomBar)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    let size = bounds.size
    previewImageView.frame = bounds
    activityIndicatorView.sizeToFit()
    activityIndicatorView.frame.origin = CGPoint(
      x: (size.width - activityIndicatorView.frame.size.width) / 2,
      y: (size.height - activityIndicatorView.frame.size.height) / 2)
    topBar.sizeToFit()
    topBar.frame = CGRect(
      x: 0,
      y: controlsHidden ? -topBar.frame.size.height : 0,
      width: size.width,
      height: topBar.frame.size.height)
    topBar.alpha = controlsHidden ? 0 : 1
    bottomBar.sizeToFit()
    bottomBar.frame = CGRect(
      x: 0,
      y: size.height - (controlsHidden ? 0 : bottomBar.frame.size.height),
      width: size.width,
      height: bottomBar.frame.size.height)
    bottomBar.alpha = controlsHidden ? 0 : 1
    overlayContainerView.frame = CGRect(
      x: 0,
      y: controlsHidden ? 0 : topBar.frame.size.height,
      width: size.width,
      height: size.height - (controlsHidden ? 0 : (topBar.frame.size.height + bottomBar.frame.size.height)))
    for overlay in overlayContainerView.subviews {
      overlay.frame = overlayContainerView.bounds
    }
    super.layoutSubviews()
  }
}
