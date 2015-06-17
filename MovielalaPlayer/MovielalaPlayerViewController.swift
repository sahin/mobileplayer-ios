//
//  MovielalaPlayerViewController.swift
//  MovielalaPlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MediaPlayer

private var globalConfiguration = MovielalaPlayerConfig()

public class MovielalaPlayerViewController: MPMoviePlayerViewController {
  public class var globalConfig: MovielalaPlayerConfig { return globalConfiguration }
  public var config: MovielalaPlayerConfig

  // controller title |> player title
  public override var title: String? {
    didSet {
      controlsView.titleLabel.text = title
    }
  }
  // Subviews.
  private let controlsView: MovielalaPlayerControlsView
  // State management properties.
  private var previousStatusBarHiddenValue: Bool!
  private var previousStatusBarStyle: UIStatusBarStyle!
  private var isFirstPlay = true
  private var wasPlayingBeforeTimeShift = false
  private var playbackTimeInterfaceUpdateTimer = NSTimer()
  private var hideControlsTimer = NSTimer()

  // MARK: - Initialization

  public init(contentURL: NSURL, config: MovielalaPlayerConfig = globalConfiguration) {
    self.config = config
    controlsView = MovielalaPlayerControlsView(config: config)
    super.init(contentURL: contentURL)
    initializeMovielalaPlayerViewController()
  }

  public init(contentURL: NSURL, configFileURL: NSURL) {
    let config = SkinParser.parseConfigFromURL(configFileURL) ?? globalConfiguration
    self.config = config
    controlsView = MovielalaPlayerControlsView(config: config)
    super.init(contentURL: contentURL)
    initializeMovielalaPlayerViewController()
  }

  public init(youTubeURL: NSURL, configFileURL: NSURL) {
    let config = SkinParser.parseConfigFromURL(configFileURL) ?? globalConfiguration
    self.config = config
    controlsView = MovielalaPlayerControlsView(config: config)
    super.init(contentURL: NSURL())
    Youtube.h264videosWithYoutubeURL(youTubeURL, completion: { videoInfo, error in
      if let
        videoURLString = videoInfo?["url"] as? String,
        videoTitle = videoInfo?["title"] as? String {
          if let isStream = videoInfo?["isStream"] as? Bool,
            image = videoInfo?["image"] as? String {
              if let imageURL = NSURL(string: image),
                data = NSData(contentsOfURL: imageURL),
                bgImage = UIImage(data: data) {
                  self.controlsView.backgroundImageView.image = bgImage
              }
          }
          self.moviePlayer.contentURL = NSURL(string: videoURLString)
          self.title = videoTitle
      }
    })
    initializeMovielalaPlayerViewController()
  }

  public required init(coder aDecoder: NSCoder) {
    fatalError("storyboards are incompatible with truth and beauty")
  }

  private func initializeMovielalaPlayerViewController() {
    edgesForExtendedLayout = .None
    moviePlayer.scalingMode = .AspectFit
    moviePlayer.controlStyle = .None
    initializeNotificationObservers()
    initializeControlsView()
  }

  private func initializeNotificationObservers() {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(
      self,
      selector: "handleMoviePlayerPlaybackStateDidChangeNotification",
      name: MPMoviePlayerPlaybackStateDidChangeNotification,
      object: moviePlayer)
    notificationCenter.removeObserver(
      self,
      name: MPMoviePlayerPlaybackDidFinishNotification,
      object: moviePlayer)
    notificationCenter.addObserver(
      self,
      selector: "showPostrollOrDismissAtVideoEnd",
      name: MPMoviePlayerPlaybackDidFinishNotification,
      object: moviePlayer)
    notificationCenter.removeObserver(
      self,
      name: "goToCustomTimeSliderWithTime",
      object: nil)
    notificationCenter.addObserver(
      self,
      selector: "goToCustomTimeSliderWithTime:",
      name: "goToCustomTimeSliderWithTime",
      object: nil)
    initializeButtonNotificationObservers(notificationCenter)
  }

  private func initializeButtonNotificationObservers(notificationCenter: NSNotificationCenter) {
    notificationCenter.removeObserver(
      self,
      name: "playVideoPlayer",
      object: nil)
    notificationCenter.addObserver(
      self,
      selector: "playVideoPlayer",
      name: "playVideoPlayer",
      object: nil)
    notificationCenter.removeObserver(
      self,
      name: "pauseVideoPlayer",
      object: nil)
    notificationCenter.addObserver(
      self,
      selector: "pauseVideoPlayer",
      name: "pauseVideoPlayer",
      object: nil)
  }

  private func initializeControlsView() {
    controlsView.closeButton.addTarget(
      self,
      action: "dismiss",
      forControlEvents: .TouchUpInside)
    controlsView.shareButton.addTarget(
      self,
      action: "shareContent",
      forControlEvents: .TouchUpInside)
    controlsView.playButton.addTarget(
      self,
      action: "togglePlay",
      forControlEvents: .TouchUpInside)
    controlsView.customTimeSliderView.timeSlider.addTarget(
      self,
      action: "timeShiftDidBegin",
      forControlEvents: .TouchDown)
    controlsView.customTimeSliderView.timeSlider.addTarget(
      self,
      action: "goToTimeSliderTime",
      forControlEvents: .ValueChanged)
    controlsView.customTimeSliderView.timeSlider.addTarget(
      self,
      action: "timeShiftDidEnd",
      forControlEvents: .TouchUpInside | .TouchUpOutside | .TouchCancel)
    initializeControlsViewTapRecognizers()
  }

  private func initializeControlsViewTapRecognizers() {
    let singleTapRecognizer = UITapGestureRecognizer(
      target: self,
      action: "toggleControlVisibility")
    singleTapRecognizer.numberOfTapsRequired = 1
    controlsView.addGestureRecognizer(singleTapRecognizer)
    let doubleTapRecognizer = UITapGestureRecognizer(
      target: self,
      action: "toggleVideoScalingMode")
    doubleTapRecognizer.numberOfTapsRequired = 2
    controlsView.addGestureRecognizer(doubleTapRecognizer)
    singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(controlsView)
    NSTimer.scheduledTimerWithTimeInterval(
      0.0,
      target: self,
      selector: "updateBufferInterface",
      userInfo: nil, repeats: true)
    NSTimer.scheduledTimerWithTimeInterval(
      0.0,
      target: self,
      selector: "updateTimeSliderViewInterface",
      userInfo: nil, repeats: true)
  }

  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    // Force hide status bar.
    previousStatusBarHiddenValue = UIApplication.sharedApplication().statusBarHidden
    UIApplication.sharedApplication().statusBarHidden = true
    setNeedsStatusBarAppearanceUpdate()
  }

  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    controlsView.frame = view.bounds
  }

  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    // Restore status bar appearance.
    UIApplication.sharedApplication().statusBarHidden = previousStatusBarHiddenValue
    setNeedsStatusBarAppearanceUpdate()
  }

  deinit {
    playbackTimeInterfaceUpdateTimer.invalidate()
    hideControlsTimer.invalidate()
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  // MARK: - Internal Helpers

  private func doFirstPlaySetupIfNeeded() {
    if isFirstPlay {
      isFirstPlay = false
      controlsView.backgroundImageView.removeFromSuperview()
      controlsView.activityIndicatorView.stopAnimating()
      updateTimeLabel(controlsView.durationLabel, time: moviePlayer.duration)
      playbackTimeInterfaceUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(
        0.0,
        target: self,
        selector: "updatePlaybackTimeInterface",
        userInfo: nil,
        repeats: true)
      playbackTimeInterfaceUpdateTimer.fire()
      if let firstPlayCallback = config.firstPlayCallback {
        firstPlayCallback(playerVC: self)
      }
    }
  }

  private func updateTimeSlider() {
    controlsView.customTimeSliderView.maximumValue = Float(moviePlayer.duration)
    controlsView.customTimeSliderView.value = Float(moviePlayer.currentPlaybackTime)
  }

  private func updateTimeLabel(label: UILabel, time: NSTimeInterval) {
    if time.isNaN || time == NSTimeInterval.infinity {
      return
    }
    let hours = UInt(time / 3600)
    let minutes = UInt((time / 60) % 60)
    let seconds = UInt(time % 60)
    var timeLabelText = NSString(format: "%02lu:%02lu", minutes, seconds) as String
    label.text = checkTimeLabelText(timeLabelText)
    if hours > 0 {
      label.text = NSString(format: "%02lu:%@", hours, label.text!) as String
    }
  }

  private func checkTimeLabelText(text: NSString) -> String {
    if text.length > 8 {
      return String("00:00")
    }
    return String(text)
  }

  // MARK: - Public API

  public final func toggleVideoScalingMode() {
    if moviePlayer.scalingMode != .AspectFill {
      moviePlayer.scalingMode = .AspectFill
    } else {
      moviePlayer.scalingMode = .AspectFit
    }
  }

  public final func updateBufferInterface() {
    if var bufferCalculate =
      progressBarBufferPercentWithMoviePlayer(moviePlayer) as? NSTimeInterval {
        controlsView.customTimeSliderView.refreshBufferPercentRatio(
          bufferRatio: CGFloat(bufferCalculate),
          totalDuration: CGFloat(moviePlayer.duration)
        )
    }
  }

  public final func updateTimeSliderViewInterface(){
    controlsView.customTimeSliderView.refreshVideoProgressPercentRaito(
      videoRaito: CGFloat(moviePlayer.currentPlaybackTime),
      totalDuration: CGFloat(moviePlayer.duration)
    )
    controlsView.customTimeSliderView.refreshCustomTimeSliderPercentRatio()
  }

  public final func updatePlaybackTimeInterface() {
    updateTimeSlider()
    updateTimeLabel(controlsView.playbackTimeLabel, time: moviePlayer.currentPlaybackTime)
    controlsView.setNeedsLayout()
  }

  public final func toggleControlVisibility() {
    if controlsView.controlsHidden {
      controlsView.controlsHidden = false
      resetHideControlsTimer()
    } else {
      controlsView.controlsHidden = true
      hideControlsTimer.invalidate()
    }
  }

  public final func shareContent() {
    if let shareCallback = config.shareConfig.shareCallback {
      moviePlayer.pause()
      shareCallback(playerVC: self)
    }
  }

  public final func dismiss() {
    moviePlayer.stop()
    if let nc = navigationController {
      nc.popViewControllerAnimated(true)
    } else {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }

  private func resetHideControlsTimer() {
    hideControlsTimer.invalidate()
    hideControlsTimer = NSTimer.scheduledTimerWithTimeInterval(
      2,
      target: self,
      selector: "hideControlsIfPlaying",
      userInfo: nil,
      repeats: false)
  }

final func progressBarBufferPercentWithMoviePlayer(
    player: MPMoviePlayerController) -> AnyObject? {
      if var movieAccessLog = player.accessLog,
        var arrEvents = movieAccessLog.events {
          var totalValue = 0.0;
          for i in 0..<arrEvents.count {
            totalValue = totalValue + Double(arrEvents[i].segmentsDownloadedDuration)
          }
          return totalValue
      }
      return nil
  }

}

// MARK: - MovielalaPlayerOverlayViewControllerDelegate

extension MovielalaPlayerViewController: MovielalaPlayerOverlayViewControllerDelegate {
  func dismissMovielalaPlayerOverlay(overlayVC: MovielalaPlayerOverlayViewController) {
    if overlayVC.view.superview == controlsView.overlayContainerView {
      overlayVC.willMoveToParentViewController(nil)
      overlayVC.view.removeFromSuperview()
      overlayVC.removeFromParentViewController()
    }
  }

  // MARK: - Event Handling

  func togglePlay() {
    let state = moviePlayer.playbackState
    if state == .Playing || state == .Interrupted {
      moviePlayer.pause()
    } else {
      moviePlayer.play()
    }
  }

  func pauseVideoPlayer() {
    moviePlayer.pause()
  }

  func playVideoPlayer() {
    moviePlayer.play()
  }

  final func handleMoviePlayerPlaybackStateDidChangeNotification() {
    let state = moviePlayer.playbackState
    updatePlaybackTimeInterface()
    if state == .Playing || state == .Interrupted {
      doFirstPlaySetupIfNeeded()
      controlsView.playButton.setImage(config.controlbarConfig.pauseButtonImage, forState: .Normal)
      if !controlsView.controlsHidden {
        resetHideControlsTimer()
      }
      if let pauseViewController = config.pauseViewController {
        dismissMovielalaPlayerOverlay(pauseViewController)
      }
    } else {
      controlsView.playButton.setImage(config.controlbarConfig.playButtonImage, forState: .Normal)
      hideControlsTimer.invalidate()
      controlsView.controlsHidden = false
      if let pauseViewController = config.pauseViewController {
        addChildViewController(pauseViewController)
        controlsView.overlayContainerView.addSubview(pauseViewController.view)
        pauseViewController.didMoveToParentViewController(self)
        pauseViewController.delegate = self
      }
    }
  }

  final func hideControlsIfPlaying() {
    let state = moviePlayer.playbackState
    if state == .Playing || state == .Interrupted {
      controlsView.controlsHidden = true
    }
  }

  final func showPostrollOrDismissAtVideoEnd() {
    if let postrollVC = config.postrollViewController {
      showOverlayViewController(postrollVC)
      if let endCallback = config.endCallback {
        endCallback(playerVC: self)
      }
    } else {
      dismiss()
    }
  }

  private func showOverlayViewController(overlayVC: MovielalaPlayerOverlayViewController) {
    addChildViewController(overlayVC)
    overlayVC.view.clipsToBounds = true
    controlsView.overlayContainerView.addSubview(overlayVC.view)
    overlayVC.didMoveToParentViewController(self)
  }

  final func timeShiftDidBegin() {
    let state = moviePlayer.playbackState
    wasPlayingBeforeTimeShift = (state == .Playing || state == .Interrupted)
    moviePlayer.pause()
  }

  final func goToTimeSliderTime() {
    var timeVal = controlsView.customTimeSliderView.value
    moviePlayer.currentPlaybackTime = NSTimeInterval(controlsView.customTimeSliderView.value)
  }

  final func goToCustomTimeSliderWithTime(notification: NSNotification) {
    if let
      userInfo = notification.userInfo as? [String: NSTimeInterval],
      messageString = userInfo["time"] {
        var playbackTime = messageString
        moviePlayer.currentPlaybackTime = playbackTime
        moviePlayer.play()
    }
  }

  final func timeShiftDidEnd() {
    if wasPlayingBeforeTimeShift {
      moviePlayer.play()
    }
  }
}
