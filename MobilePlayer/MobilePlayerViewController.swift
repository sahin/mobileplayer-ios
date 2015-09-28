//
//  MobilePlayerViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MediaPlayer

public protocol MobilePlayerViewControllerDelegate: class {
  func mobilePlayerViewControllerStateDidChange(mobilePlayerViewController: MobilePlayerViewController)
  func mobilePlayerViewController(
    mobilePlayerViewController: MobilePlayerViewController,
    didEncounterError error: NSError)
  func mobilePlayerViewController(
    mobilePlayerViewController: MobilePlayerViewController,
    buttonWithIdentifierDidGetTapped identifier: String)
  func mobilePlayerViewControllerPlaybackDidFinish(mobilePlayerViewController: MobilePlayerViewController)
}

public class MobilePlayerViewController: MPMoviePlayerViewController {
  // MARK: - Properties

  // MARK: Delegation
  public var delegate: MobilePlayerViewControllerDelegate?

  // MARK: Player State
  public enum State {
    case Idle, Buffering, Playing, Paused
  }
  public private(set) var previousState: State = .Idle
  public private(set) var state: State = .Idle {
    didSet {
      previousState = oldValue
    }
  }

  // MARK: Player Configuration
  private static let playbackInterfaceUpdateInterval = 0.25
  public static let globalConfig = MobilePlayerConfig()
  public var config: MobilePlayerConfig

  // MARK: Mapped Properties
  public override var title: String? {
    didSet {
      guard let titleLabel = getViewForElementWithIdentifier("title") as? Label else { return}
      titleLabel.text = title
      titleLabel.superview?.setNeedsLayout()
    }
  }
  public var shouldAutoplay: Bool {
    get {
      return moviePlayer.shouldAutoplay
    }
    set {
      moviePlayer.shouldAutoplay = newValue
    }
  }

  // MARK: Subviews
  private let controlsView: MobilePlayerControlsView

  // MARK: Overlays
  private var timedOverlays = [TimedOverlayInfo]()

  // MARK: Sharing
  public var shareItems: [AnyObject]?

  // MARK: Other Properties
  private var previousStatusBarHiddenValue: Bool!
  private var previousStatusBarStyle: UIStatusBarStyle!
  private var isFirstPlay = true
  private var seeking = false
  private var wasPlayingBeforeSeek = false
  private var playbackInterfaceUpdateTimer: NSTimer?
  private var hideControlsTimer: NSTimer?

  // MARK: - Initialization

  public init(
    contentURL: NSURL,
    config: MobilePlayerConfig = MobilePlayerViewController.globalConfig,
    shareItems: [AnyObject]? = nil) {
      self.config = config
      controlsView = MobilePlayerControlsView(config: config)
      self.shareItems = shareItems
      super.init(contentURL: contentURL)
      initializeMobilePlayerViewController()
  }

  public required init?(coder aDecoder: NSCoder) {
    config = MobilePlayerViewController.globalConfig
    controlsView = MobilePlayerControlsView(config: config)
    super.init(coder: aDecoder)
    initializeMobilePlayerViewController()
  }

  private func initializeMobilePlayerViewController() {
    edgesForExtendedLayout = .None
    moviePlayer.scalingMode = .AspectFit
    moviePlayer.controlStyle = .None
    initializeNotificationObservers()
    initializeControlsView()
    parseContentURLIfNeeded()
    if let watermarkConfig = config.watermark {
      showOverlayViewController(WatermarkViewController(config: watermarkConfig))
    }
  }

  private func initializeNotificationObservers() {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserverForName(
      MPMoviePlayerPlaybackStateDidChangeNotification,
      object: moviePlayer,
      queue: NSOperationQueue.mainQueue()) { notification in
        self.handleMoviePlayerPlaybackStateDidChangeNotification()
        self.delegate?.mobilePlayerViewControllerStateDidChange(self)
    }
    notificationCenter.removeObserver(
      self,
      name: MPMoviePlayerPlaybackDidFinishNotification,
      object: moviePlayer)
    notificationCenter.addObserverForName(
      MPMoviePlayerPlaybackDidFinishNotification,
      object: moviePlayer,
      queue: NSOperationQueue.mainQueue()) { notification in
        if let postrollVC = self.config.postrollViewController {
          self.showOverlayViewController(postrollVC)
        }
        self.delegate?.mobilePlayerViewControllerPlaybackDidFinish(self)
    }
  }

  private func initializeControlsView() {
    (getViewForElementWithIdentifier("playback") as? Slider)?.delegate = self
    (getViewForElementWithIdentifier("close") as? Button)?.addCallback(
      dismiss,
      forControlEvents: .TouchUpInside)
    (getViewForElementWithIdentifier("action") as? Button)?.addCallback(
      showContentActions,
      forControlEvents: .TouchUpInside)
    (getViewForElementWithIdentifier("play") as? ToggleButton)?.addCallback(
      {
        self.resetHideControlsTimer()
        self.togglePlayback()
      },
      forControlEvents: .TouchUpInside)
    initializeControlsViewTapRecognizers()
  }

  private func initializeControlsViewTapRecognizers() {
    let singleTapRecognizer = UITapGestureRecognizer(callback: toggleControls)
    singleTapRecognizer.numberOfTapsRequired = 1
    controlsView.addGestureRecognizer(singleTapRecognizer)
    let doubleTapRecognizer = UITapGestureRecognizer(callback: toggleVideoScalingMode)
    doubleTapRecognizer.numberOfTapsRequired = 2
    controlsView.addGestureRecognizer(doubleTapRecognizer)
    singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
  }

  // MARK: - View Controller Lifecycle

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(controlsView)
    playbackInterfaceUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(
      MobilePlayerViewController.playbackInterfaceUpdateInterval,
      callback: updatePlaybackInterface,
      repeats: true)
    if let preRollVC = self.config.prerollViewController {
      shouldAutoplay = false
      showOverlayViewController(preRollVC)
    }
  }

  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    controlsView.frame = view.bounds
  }

  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    // Force hide status bar.
    previousStatusBarHiddenValue = UIApplication.sharedApplication().statusBarHidden
    UIApplication.sharedApplication().statusBarHidden = true
    setNeedsStatusBarAppearanceUpdate()
  }

  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    // Restore status bar appearance.
    UIApplication.sharedApplication().statusBarHidden = previousStatusBarHiddenValue
    setNeedsStatusBarAppearanceUpdate()
  }

  // MARK: - Deinitialization

  deinit {
    playbackInterfaceUpdateTimer?.invalidate()
    hideControlsTimer?.invalidate()
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  // MARK: - Internal Helpers

  private func parseContentURLIfNeeded() {
    guard let youtubeID = YoutubeParser.youtubeIDFromURL(moviePlayer.contentURL) else { return }
    YoutubeParser.h264videosWithYoutubeID(youtubeID) { videoInfo, error in
      if let error = error {
        self.delegate?.mobilePlayerViewController(self, didEncounterError: error)
      }
      guard let videoInfo = videoInfo else { return }
      self.title = self.title ?? videoInfo.title
      if let
        previewImageURLString = videoInfo.previewImageURL,
        previewImageURL = NSURL(string: previewImageURLString) {
          NSURLSession.sharedSession().dataTaskWithURL(previewImageURL) { data, response, error in
            guard let data = data else { return }
            dispatch_async(dispatch_get_main_queue()) {
              self.controlsView.previewImageView.image = UIImage(data: data)
            }
          }
      }
      if let videoURL = videoInfo.videoURL {
        self.moviePlayer.contentURL = NSURL(string: videoURL)
      }
    }
  }

  private func doFirstPlaySetupIfNeeded() {
    if isFirstPlay {
      isFirstPlay = false
      controlsView.previewImageView.hidden = true
      controlsView.activityIndicatorView.stopAnimating()
      guard let durationLabel = getViewForElementWithIdentifier("duration") as? Label else { return }
      durationLabel.text = textForPlaybackTime(moviePlayer.duration)
      durationLabel.superview?.setNeedsLayout()
    }
  }

  private func updatePlaybackInterface() {
    if let playbackSlider = getViewForElementWithIdentifier("playback") as? Slider {
      playbackSlider.maximumValue = Float(moviePlayer.duration.isNormal ? moviePlayer.duration : 0)
      if !seeking {
        let sliderValue = Float(moviePlayer.currentPlaybackTime.isNormal ? moviePlayer.currentPlaybackTime : 0)
        playbackSlider.setValue(
          sliderValue,
          animatedForDuration: MobilePlayerViewController.playbackInterfaceUpdateInterval)
      }
      let availableValue = Float(moviePlayer.playableDuration.isNormal ? moviePlayer.playableDuration : 0)
      playbackSlider.setAvailableValue(
        availableValue,
        animatedForDuration: MobilePlayerViewController.playbackInterfaceUpdateInterval)
    }
    if let currentTimeLabel = getViewForElementWithIdentifier("currentTime") as? Label {
      currentTimeLabel.text = textForPlaybackTime(moviePlayer.currentPlaybackTime)
      currentTimeLabel.superview?.setNeedsLayout()
    }
    if let remainingTimeLabel = getViewForElementWithIdentifier("remainingTime") as? Label {
      remainingTimeLabel.text = textForPlaybackTime(moviePlayer.duration - moviePlayer.currentPlaybackTime)
      remainingTimeLabel.superview?.setNeedsLayout()
    }
    updateShownTimedOverlays()
  }

  private func textForPlaybackTime(time: NSTimeInterval) -> String {
    if !time.isNormal {
      return "00:00"
    }
    let hours = UInt(time / 3600)
    let minutes = UInt((time / 60) % 60)
    let seconds = UInt(time % 60)
    let text = NSString(format: "%02lu:%02lu", minutes, seconds) as String
    if hours > 0 {
      return NSString(format: "%02lu:%@", hours, text) as String
    } else {
      return text
    }
  }

  private func resetHideControlsTimer() {
    hideControlsTimer?.invalidate()
    hideControlsTimer = NSTimer.scheduledTimerWithTimeInterval(
      3,
      callback: {
        self.controlsView.controlsHidden = (self.state == .Playing)
      },
      repeats: false)
  }

  final func handleMoviePlayerPlaybackStateDidChangeNotification() {
    state = StateHelper.calculateStateUsing(previousState, andPlaybackState: moviePlayer.playbackState)
    let playButton = getViewForElementWithIdentifier("play") as? ToggleButton
    if state == .Playing {
      doFirstPlaySetupIfNeeded()
      playButton?.toggled = true
      if !controlsView.controlsHidden {
        resetHideControlsTimer()
      }
      config.prerollViewController?.dismiss()
      config.pauseOverlayViewController?.dismiss()
    } else {
      playButton?.toggled = false
      hideControlsTimer?.invalidate()
      controlsView.controlsHidden = false
      if let pauseOverlayViewController = config.pauseOverlayViewController where (state == .Paused && !seeking) {
        showOverlayViewController(pauseOverlayViewController)
      }
    }
  }
}

// MARK: - MobilePlayerOverlayViewControllerDelegate
extension MobilePlayerViewController: MobilePlayerOverlayViewControllerDelegate {

  func dismissMobilePlayerOverlayViewController(overlayViewController: MobilePlayerOverlayViewController) {
    overlayViewController.willMoveToParentViewController(nil)
    overlayViewController.view.removeFromSuperview()
    overlayViewController.removeFromParentViewController()
  }
}

// MARK: - TimeSliderDelegate
extension MobilePlayerViewController: SliderDelegate {

  func sliderThumbPanDidBegin(slider: Slider) {
    seeking = true
    wasPlayingBeforeSeek = (state == .Playing)
    moviePlayer.pause()
  }

  func sliderThumbDidPan(slider: Slider) {}

  func sliderThumbPanDidEnd(slider: Slider) {
    seeking = false
    moviePlayer.currentPlaybackTime = NSTimeInterval(slider.value)
    if wasPlayingBeforeSeek {
      moviePlayer.play()
    }
  }
}

// MARK: - Public API
extension MobilePlayerViewController {

  // MARK: Playback

  public func play() {
    moviePlayer.play()
  }

  public func pause() {
    moviePlayer.pause()
  }

  public func stop() {
    moviePlayer.stop()
  }

  public func togglePlayback() {
    state == .Playing ? pause() : play()
  }

  // MARK: Video Rendering

  public func fitVideo() {
    moviePlayer.scalingMode = .AspectFit
  }

  public func fillVideo() {
    moviePlayer.scalingMode = .AspectFill
  }

  public func toggleVideoScalingMode() {
    moviePlayer.scalingMode != .AspectFill ? fillVideo() : fitVideo()
  }

  // MARK: Social

  public func showContentActions() {
    if let items = self.shareItems as [AnyObject]? {
      let wasPlaying = (state == .Playing)
      moviePlayer.pause()
      let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
      activityVC.excludedActivityTypes =  [
        UIActivityTypeAssignToContact,
        UIActivityTypeSaveToCameraRoll,
        UIActivityTypePostToVimeo,
        UIActivityTypeAirDrop
      ]
      activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
        if wasPlaying {
          self.moviePlayer.play()
        }
      }
      presentViewController(activityVC, animated: true, completion: nil)
    }
  }

  // MARK: Controls

  public func showControls() {
    resetHideControlsTimer()
    controlsView.controlsHidden = false
  }

  public func hideControls() {
    hideControlsTimer?.invalidate()
    controlsView.controlsHidden = true
  }

  public func toggleControls() {
    controlsView.controlsHidden ? showControls() : hideControls()
  }

  // MARK: Elements

  public func getViewForElementWithIdentifier(identifier: String) -> UIView? {
    if let view = controlsView.topBar.getViewForElementWithIdentifier(identifier) {
      return view
    }
    return controlsView.bottomBar.getViewForElementWithIdentifier(identifier)
  }

  // MARK: Overlays

  public func showOverlayViewController(
    overlayVC: MobilePlayerOverlayViewController,
    startingAtTime presentationTime: NSTimeInterval? = nil,
    forDuration showDuration: NSTimeInterval? = nil) {
      if let presentationTime = presentationTime, showDuration = showDuration {
        timedOverlays.append(TimedOverlayInfo(startTime: presentationTime, duration: showDuration, overlay: overlayVC))
      } else {
        overlayVC.delegate = self
        addChildViewController(overlayVC)
        overlayVC.view.clipsToBounds = true
        overlayVC.view.frame = controlsView.overlayContainerView.bounds
        controlsView.overlayContainerView.addSubview(overlayVC.view)
        overlayVC.didMoveToParentViewController(self)
      }
  }

  public func clearTimedOverlays() {
    for timedOverlayInfo in timedOverlays {
      timedOverlayInfo.overlay.dismiss()
    }
    timedOverlays.removeAll()
  }

  // MARK: View Controller

  public func dismiss() {
    moviePlayer.stop()
    if let nc = navigationController {
      nc.popViewControllerAnimated(true)
    } else {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
}

// MARK: - Overlay Management
extension MobilePlayerViewController {

  final func updateShownTimedOverlays() {
    let currentTime = self.moviePlayer.currentPlaybackTime
    if !currentTime.isNormal {
      return
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      for timedOverlayInfo in self.timedOverlays {
        if timedOverlayInfo.startTime <= currentTime && currentTime <= timedOverlayInfo.startTime + timedOverlayInfo.duration {
          if timedOverlayInfo.overlay.parentViewController == nil {
            dispatch_async(dispatch_get_main_queue()) {
              self.showOverlayViewController(timedOverlayInfo.overlay)
            }
          }
        } else if timedOverlayInfo.overlay.parentViewController != nil {
          dispatch_async(dispatch_get_main_queue()) {
            timedOverlayInfo.overlay.dismiss()
          }
        }
      }
    }
  }
}
