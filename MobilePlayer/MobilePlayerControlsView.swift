//
//  MobilePlayerControlsView.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import Foundation
import MediaPlayer
import SnapKit

final class MobilePlayerControlsView: UIView {
  let buttonSize = CGSize(width: 40, height: 40)
  var orderItems = [AnyObject]()
  var controlsHidden: Bool = false {
    // Hide/show controls animated.
    didSet(oldValue) {
      if oldValue != controlsHidden {
        UIView.animateWithDuration(0.0, animations: {
          self.layoutSubviews()
        })
      }
    }
  }

  let headerView = UIView()
  let overlayContainerView = UIView()
  let footerView = UIView()
  var volumeView = VolumeControlView()
  var volumeButton = UIButton()
  var timeSliderView = TimeSliderView()
  let backgroundImageView = UIImageView()
  let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
  let closeButton = UIButton()
  let titleLabel = UILabel()
  let shareButton = UIButton()
  let playButton = UIButton()
  let playbackTimeLabel = UILabel()
  let durationLabel = UILabel()
  let remainingLabel = UILabel()
  private let config: MobilePlayerConfig

  init(config: MobilePlayerConfig) {
    self.config = config
    super.init(frame: CGRectZero)

    headerView.backgroundColor = config.headerBackgroundColor
    addSubview(headerView)
    overlayContainerView.backgroundColor = UIColor.clearColor()
    addSubview(overlayContainerView)
    footerView.backgroundColor = config.controlbarConfig.backgroundColor
    addSubview(footerView)

    // Setting view constraints
    headerView.snp_makeConstraints { (make) -> Void in
      make.width.equalTo(frame.size.width)
      make.height.equalTo(buttonSize.height)
      make.top.equalTo(0)
    }
    overlayContainerView.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(headerView.snp_bottom)
      make.height.equalTo(self.frame.height - buttonSize.height * 2)
      make.width.equalTo(self.frame.size.width)
    }
    footerView.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(overlayContainerView.snp_bottom)
      make.width.equalTo(self.frame.size.width)
      make.height.equalTo(buttonSize.height)
    }
    setLayoutConstraintsWithSkinFile(
      config.skinDictionary,
      categorysubType: "controlbar",
      layout: footerView,
      isUpdate: false)
    setLayoutConstraintsWithSkinFile(
      config.skinDictionary,
      categorysubType: "header",
      layout: headerView,
      isUpdate: false)
    initializeHeaderViews()
    initializeOverlayViews()
    initializeFooterViews()
  }

  func toggleVolumeView() {
    volumeView.hidden = !volumeView.hidden
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("storyboards are incompatible with truth and beauty")
  }

  private func initializeHeaderViews() {
    closeButton.setImage(config.closeButtonConfig.imageName, forState: .Normal)
    closeButton.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
    closeButton.tintColor = config.closeButtonConfig.tintColor
    closeButton.backgroundColor = config.closeButtonConfig.backgroundColor
    titleLabel.font = config.titleConfig.textFont
    titleLabel.textColor = config.titleConfig.textColor
    titleLabel.backgroundColor = config.titleConfig.backgroundColor
    titleLabel.textAlignment = .Center
    shareButton.setImage(config.shareButtonConfig.imageName, forState: .Normal)
    shareButton.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
    shareButton.tintColor = config.shareButtonConfig.tintColor
    shareButton.backgroundColor = config.shareButtonConfig.backgroundColor
  }

  private func initializeOverlayViews() {
    addSubview(backgroundImageView)
    activityIndicatorView.hidesWhenStopped = true
    addSubview(activityIndicatorView)
    activityIndicatorView.startAnimating()
    activityIndicatorView.snp_makeConstraints { (make) -> Void in
      make.width.height.equalTo(50)
      make.center.equalTo(overlayContainerView)
    }
  }

  private func initializeFooterViews() {
    volumeButton.setImage(config.controlbarConfig.volumeButtonImage, forState: .Normal)
    volumeButton.tintColor = config.controlbarConfig.volumeTintColor
    volumeButton.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
    volumeButton.backgroundColor = config.controlbarConfig.playButtonBackgroundColor
    playButton.setImage(config.controlbarConfig.playButtonImage, forState: .Normal)
    playButton.tintColor = config.controlbarConfig.playButtonTintColor
    playButton.backgroundColor = config.controlbarConfig.playButtonBackgroundColor
    playButton.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
    playbackTimeLabel.text = "-:-"
    playbackTimeLabel.textAlignment = .Center
    playbackTimeLabel.font = config.controlbarConfig.timeTextFont
    playbackTimeLabel.textColor = config.controlbarConfig.timeTextColor
    playbackTimeLabel.backgroundColor = config.controlbarConfig.timeBackgroundColor
    durationLabel.text = "-:-"
    durationLabel.textAlignment = .Center
    durationLabel.font = config.controlbarConfig.durationTextFont
    durationLabel.textColor = config.controlbarConfig.durationTextColor
    durationLabel.backgroundColor = config.controlbarConfig.durationBackgroundColor
    remainingLabel.text = "-:-"
    remainingLabel.textAlignment = .Center
    remainingLabel.font = config.controlbarConfig.remainingTextFont
    remainingLabel.textColor = config.controlbarConfig.remainingTextColor
    remainingLabel.backgroundColor = config.controlbarConfig.remainingBackgroundColor
    timeSliderView.backgroundColor = config.controlbarConfig.timeSliderBackgroundColor
    timeSliderView.railView.backgroundColor =
      config.controlbarConfig.timeSliderRailTintColor
    timeSliderView.bufferView.backgroundColor =
      config.controlbarConfig.timeSliderBufferTintColor
    timeSliderView.progressView.backgroundColor =
      config.controlbarConfig.timeSliderProgressTintColor
    timeSliderView.thumbView.backgroundColor = config.controlbarConfig.timeSliderThumbTintColor
    volumeView.reduceVolumeTintColor = config.controlbarConfig.volumeTintColor
    volumeView.increaseVolumeTintColor = config.controlbarConfig.volumeTintColor
    volumeView.backgroundColor = config.controlbarConfig.volumeBackgroundColor
    volumeView.tintColor = config.controlbarConfig.volumeTintColor
    volumeView.hidden = true
    overlayContainerView.addSubview(volumeView)
    volumeView.snp_makeConstraints { (make) -> Void in
      make.size.equalTo(CGSizeMake(35, 150))
      make.right.equalTo(-3)
      make.bottom.equalTo(-5)
    }
  }
}

extension MobilePlayerControlsView {

  private func setLayoutConstraintsWithSkinFile(
    skinFile: [String: AnyObject],
    categorysubType: String,
    layout: UIView,
    isUpdate: Bool) {
    if let skin = skinFile as [String: AnyObject]? {
      if var controlbar = skin[categorysubType] as? NSArray {
        var arrValues = NSMutableArray()
        var views: [UIView] = []
        var skinItemOrders: NSArray = NSArray()
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        self.addSubview(layout)
        setBackgroundColorWithLayout(layout, skin: skin)
        skinItemOrders = controlbar.sortedArrayUsingDescriptors([descriptor])
        for (index,viewItem) in enumerate(skinItemOrders) {
          if let element = viewItem["type"] as? String {
            if element == "view" {
              if let slider = viewItem["subType"] as? String {
                if slider == "timeSlider" {
                  timeSliderCases(viewItem)
                  views.append(timeSliderView)
                  layout.addSubview(timeSliderView)
                }else{
                  if slider == "seperator" {
                    let seperator = UIView()
                    views.append(seperator)
                    layout.addSubview(seperator)
                  }else{
                    let customView = UIView()
                    viewCases(viewItem, layout: layout)
                    views.append(customView)
                    layout.addSubview(customView)
                  }
                }
              }
            }
            if element == "label" {
              if let slider = viewItem["subType"] as? String {
                if slider == "title" {
                  views.append(titleLabel)
                  layout.addSubview(titleLabel)
                }else{
                  if slider == "time" {
                    views.append(playbackTimeLabel)
                    layout.addSubview(playbackTimeLabel)
                  }else{
                    if slider == "remaining" {
                      views.append(remainingLabel)
                      layout.addSubview(remainingLabel)
                    }else{
                      if slider == "duration" {
                        views.append(durationLabel)
                        layout.addSubview(durationLabel)
                      }else{
                        let label = UILabel()
                        labelCases(label, viewItem: viewItem)
                        views.append(label)
                        layout.addSubview(label)
                      }
                    }
                  }
                }
              }
            }
            if element == "button" {
              if let subType = viewItem["subType"] as? String {
                if subType == "play" {
                  views.append(playButton)
                  layout.addSubview(playButton)
                }else{
                  if subType == "volume" {
                    views.append(volumeButton)
                    layout.addSubview(volumeButton)
                  }else{
                    if subType == "close" {
                      views.append(closeButton)
                      layout.addSubview(closeButton)
                    }else{
                      if subType == "share" {
                        views.append(shareButton)
                        layout.addSubview(shareButton)
                      }else{
                        let button = UIButton()
                        buttonCases(button, viewItem: viewItem)
                        views.append(button)
                        layout.addSubview(button)
                      }
                    }
                  }
                }
              }
            }
          }
        }
        setLayoutPositionWithSkinItems(skinItemOrders, views: views, layout: layout)
      }
    }
  }

  private func setBackgroundColorWithLayout(layout: UIView, skin: [String: AnyObject]) {
    if let bgColor = skin["backgroundColor"] as? String {
      if let alpha = skin["alpha"] as? CGFloat {
        layout.backgroundColor = UIColor(hexString: bgColor).colorWithAlphaComponent(alpha)
      }else{
        layout.backgroundColor = UIColor(hexString: bgColor)
      }
    }else{
      layout.backgroundColor = UIColor.clearColor()
    }
  }

  private func viewCases(viewItem: AnyObject, layout: UIView) {
    if let bgColor = viewItem["backgroundColor"] as? String {
      if let alpha = viewItem["alpha"] as? CGFloat {
        layout.backgroundColor = UIColor(hexString: bgColor).colorWithAlphaComponent(alpha)
      }else{
        layout.backgroundColor = UIColor(hexString: bgColor)
      }
    }else{
      layout.backgroundColor = UIColor.clearColor()
    }
  }

  private func timeSliderCases(viewItem: AnyObject){
    if let sliderRailRadius = viewItem["railRadius"] as? CGFloat {
      timeSliderView.railView.layer.cornerRadius = sliderRailRadius
    }
    if let sliderRailHeight = viewItem["railHeight"] as? CGFloat {
      timeSliderView.railHeight = sliderRailHeight
    }
    if let thumbRadius = viewItem["thumbRadius"] as? CGFloat {
      timeSliderView.thumbViewRadius = thumbRadius
    }
    if let thumbViewHeight = viewItem["thumbHeight"] as? CGFloat {
      timeSliderView.thumbHeight = thumbViewHeight
    }
    if let thumbViewWidth = viewItem["thumbWidth"] as? CGFloat {
      timeSliderView.thumbWidth = thumbViewWidth
    }
    if let thumbViewBorder = viewItem["thumbBorder"] as? CGFloat {
      timeSliderView.thumbBorder = thumbViewBorder
    }
    if let thumbViewBorderColor = viewItem["thumbBorderColor"] as? String {
      timeSliderView.thumbBorderColor = UIColor(hexString: thumbViewBorderColor)
    }
  }

  private func labelCases(label: UILabel, viewItem: AnyObject) {
    if let bgColor = viewItem["backgroundColor"] as? String {
      label.backgroundColor = UIColor(hexString: bgColor)
    }
    if let textColor = viewItem["textColor"] as? String {
      label.textColor = UIColor(hexString: textColor)
    }
    if let textColor = viewItem["textColor"] as? String {
      label.textColor = UIColor(hexString: textColor)
    }
    if let textFontSize = viewItem["textFontSize"] as? CGFloat {
      if let textFont = viewItem["textFont"] as? String {
        label.font = UIFont(name: textFont, size: textFontSize)
      }
    }
  }

  private func buttonCases(button: UIButton, viewItem: AnyObject) {
    if let color = viewItem["backgroundColor"] as? String {
      button.backgroundColor = UIColor(hexString: color)
    }
    if let tintColor = viewItem["tintColor"] as? String {
      button.tintColor = UIColor(hexString: tintColor)
    }
    if let img = viewItem["image"] as? String {
      button.setImage(UIImage(named: img), forState: UIControlState.Normal)
    }else {
      if let img = viewItem["playImage"] as? String {
        button.setImage(UIImage(named: img), forState: UIControlState.Normal)
      }
    }
  }

  private func setLayoutPositionWithSkinItems(
    skinItemOrders: NSArray,
    views: [UIView],
    layout: UIView) {
    switch skinItemOrders.count {
    case 1:
      if let subType = skinItemOrders.objectAtIndex(0)["subType"] as? String {
        if subType == "timeSlider" || subType == "title" {
          views[0].snp_makeConstraints { (make) -> Void in
            make.height.equalTo(layout.snp_height)
            make.top.equalTo(layout).offset(0)
            make.left.equalTo(layout.snp_left)
            make.right.equalTo(layout.snp_right)
          }
        }
      }
    case 2:
      for (index, referedView) in enumerate(skinItemOrders) {
        if index == 0 {
          if let subType = referedView["subType"] as? String {
            if subType == "timeSlider" || subType == "title" {
              views[index].snp_makeConstraints { (make) -> Void in
                make.height.equalTo(layout.snp_height)
                make.top.equalTo(layout).offset(0)
                make.left.equalTo(layout.snp_left)
                make.right.equalTo(views[index+1].snp_left)
              }
            }else{
              views[index].snp_makeConstraints { (make) -> Void in
                make.height.equalTo(layout.snp_height)
                make.width.equalTo(buttonSize.width)
                make.top.equalTo(layout).offset(0)
                make.edges.equalTo(layout).offset(0)
              }
            }
          }
        }else{
          if let subType = referedView["subType"] as? String {
            views[index].snp_makeConstraints { (make) -> Void in
              if subType == "timeSlider" || subType == "title" { } else {
                make.width.equalTo(buttonSize.width)
              }
              make.height.equalTo(layout.snp_height)
              make.top.equalTo(layout).offset(0)
              make.left.equalTo(views[index-1].snp_right)
              make.right.equalTo(layout.snp_right)
            }
          }
        }
      }
    default:
      setLayoutPositionDefaulCaseWithSkinItems(skinItemOrders, views: views, layout: layout)
    }
  }

  private func setLayoutPositionDefaulCaseWithSkinItems(
    skinItemOrders: NSArray,
    views: [UIView],
    layout: UIView) {
    for (index, referedView) in enumerate(skinItemOrders) {
      if index == 0 {
        if let subType = referedView["subType"] as? String {
          if subType == "timeSlider" || subType == "title" {
            views[index].snp_makeConstraints { (make) -> Void in
              make.height.equalTo(layout.snp_height)
              make.top.equalTo(layout).offset(0)
              make.left.equalTo(layout.snp_left)
              make.right.equalTo(views[index+1].snp_left)
            }
          }else{
            views[index].snp_makeConstraints { (make) -> Void in
              make.height.equalTo(layout.snp_height)
              if let subType = referedView["subType"] as? String {
                if subType == "seperator" {
                  if let seperatorWidth = referedView["width"] as? CGFloat {
                    make.width.equalTo(seperatorWidth)
                  }else{
                    make.width.equalTo(15)
                  }
                }else{
                  make.width.equalTo(buttonSize.width)
                }
              }
              make.top.equalTo(layout).offset(0)
              make.edges.equalTo(layout).offset(0)
            }
          }
        }
      }else{
        if let subType = referedView["subType"] as? String {
          if subType == "timeSlider" || subType == "title" {
            views[index].snp_makeConstraints { (make) -> Void in
              make.height.equalTo(layout.snp_height)
              make.top.equalTo(layout).offset(0)
              make.left.equalTo(views[index-1].snp_right)
              if index == skinItemOrders.count - 1 {
                make.right.equalTo(layout.snp_right)
              }else{
                make.right.equalTo(views[index+1].snp_left)
              }
            }
          }else{
            views[index].snp_makeConstraints { (make) -> Void in
              make.height.equalTo(layout.snp_height)
              if let subType = referedView["subType"] as? String {
                if subType == "seperator" {
                  if let seperatorWidth = referedView["width"] as? CGFloat {
                    make.width.equalTo(seperatorWidth)
                  }else{
                    make.width.equalTo(15)
                  }
                }else{
                  make.width.equalTo(buttonSize.width)
                }
              }
              make.top.equalTo(layout).offset(0)
              if index == skinItemOrders.count - 1 {
                make.left.equalTo(views[index-1].snp_right)
                make.right.equalTo(layout.snp_right)
              }else{
                make.left.equalTo(views[index-1].snp_right)
                make.right.equalTo(views[index+1].snp_left)
              }
            }
          }
        }
      }
    }
  }

  func updateConstraintsWithLayout(frame: CGRect) {
    self.frame = frame
    headerView.snp_updateConstraints { (make) -> Void in
      make.width.equalTo(frame.size.width)
      make.height.equalTo(buttonSize.height)
      make.top.equalTo(0)
    }
    overlayContainerView.snp_updateConstraints { (make) -> Void in
      make.top.equalTo(headerView.snp_bottom)
      make.height.equalTo(frame.height - buttonSize.height * 2)
      make.width.equalTo(frame.size.width)
    }
    footerView.snp_updateConstraints { (make) -> Void in
      make.top.equalTo(overlayContainerView.snp_bottom)
      make.width.equalTo(frame.size.width)
      make.height.equalTo(buttonSize.height)
    }
  }
}
