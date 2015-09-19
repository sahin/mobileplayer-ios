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
  func mobilePlayerViewController(mobilePlayerViewController: MobilePlayerViewController, didEncounterError error: NSError)
  func mobilePlayerViewController(mobilePlayerViewController: MobilePlayerViewController, buttonWithIdentifierDidGetTapped identifier: String)
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
      (getViewForElementWithIdentifier("title") as? Label)?.text = title
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
  public var overlayController = MobilePlayerOverlayViewController()
  public var isShowOverlay = false
  public var timedOverlays = [[String: AnyObject]]()

  // MARK: Sharing
  public var shareItems: [AnyObject]?

  // MARK: Other Properties
  private var previousStatusBarHiddenValue: Bool!
  private var previousStatusBarStyle: UIStatusBarStyle!
  private var isFirstPlay = true
  private var isFirstPlayPreRoll = true
  private var seeking = false
  private var wasPlayingBeforeSeek = false
  private var playbackInterfaceUpdateTimer: NSTimer?
  private var hideControlsTimer: NSTimer?

  // MARK: - Initialization

  public init(contentURL: NSURL, config: MobilePlayerConfig = MobilePlayerViewController.globalConfig, shareItems: [AnyObject]? = nil) {
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
    if config.prerollViewController != nil {
      shouldAutoplay = false
    }
    edgesForExtendedLayout = .None
    moviePlayer.scalingMode = .AspectFit
    moviePlayer.controlStyle = .None
    initializeNotificationObservers()
    initializeControlsView()
    parseContentURLIfNeeded()
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
    (getViewForElementWithIdentifier("share") as? Button)?.addCallback(shareContent, forControlEvents: .TouchUpInside)
    (getViewForElementWithIdentifier("play") as? Button)?.addCallback(
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
//    if let youtubeID = YoutubeParser.youtubeIDFromURL(moviePlayer.contentURL) {
//      YoutubeParser.h264videosWithYoutubeID(youtubeID, completion: { videoInfo, error in
//        if let error = error {
//          // TODO: Delegate the error.
//        } else {
//          if self.title == nil {
//            self.title = videoInfo.title
//          }
//          if let
//            previewImageURLString = videoInfo.previewImageURL,
//            previewImageURL = NSURL(string: previewImageURLString) {
//              NSURLSession.sharedSession().dataTaskWithURL(previewImageURL) { data, response, error in
//                dispatch_async(dispatch_get_main_queue()) {
//                  self.controlsView.backgroundImageView.image = UIImage(data: data)
//                }
//              }.resume()
//          }
//          if let videoURL = videoInfo.videoURL {
//            self.moviePlayer.contentURL = NSURL(string: videoURL)
//          }
//        }
//      })
//    }
  }

  private func doFirstPlaySetupIfNeeded() {
    if isFirstPlay {
      isFirstPlay = false
      controlsView.previewImageView.removeFromSuperview()
      controlsView.activityIndicatorView.stopAnimating()
      (getViewForElementWithIdentifier("duration") as? Label)?.text = textForPlaybackTime(moviePlayer.duration)
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
    (getViewForElementWithIdentifier("currentTime") as? Label)?.text = textForPlaybackTime(moviePlayer.currentPlaybackTime)
    updateShownTimedOverlays()
  }

  private func textForPlaybackTime(time: NSTimeInterval) -> String {
    if !time.isNormal {
      return "-:-"
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
      2,
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
      if let prerollViewController = config.prerollViewController {
        dismissMobilePlayerOverlay(prerollViewController)
      }
      if let pauseViewController = config.pauseViewController {
        dismissMobilePlayerOverlay(pauseViewController)
      }
    } else {
      playButton?.toggled = false
      hideControlsTimer?.invalidate()
      controlsView.controlsHidden = false
      if let pauseViewController = config.pauseViewController {
        // FIXME: Constraints.
        addChildViewController(pauseViewController)
        controlsView.overlayContainerView.addSubview(pauseViewController.view)
        pauseViewController.didMoveToParentViewController(self)
        pauseViewController.delegate = self
      }
    }
  }
}

// MARK: - MobilePlayerOverlayViewControllerDelegate
extension MobilePlayerViewController: MobilePlayerOverlayViewControllerDelegate {

  func dismissMobilePlayerOverlay(overlayVC: MobilePlayerOverlayViewController) {
    if overlayVC.view.superview == controlsView.overlayContainerView {
      overlayVC.willMoveToParentViewController(nil)
      overlayVC.view.removeFromSuperview()
      overlayVC.removeFromParentViewController()
    }
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
    if state == .Playing {
      pause()
    } else {
      if isFirstPlayPreRoll {
        if let preRoll = self.config.prerollViewController {
          dismissMobilePlayerOverlay(preRoll)
          isFirstPlayPreRoll = false
        }
      }
      play()
    }
  }

  // MARK: Video Rendering

  public func fitVideo() {
    moviePlayer.scalingMode = .AspectFit
  }

  public func fillVideo() {
    moviePlayer.scalingMode = .AspectFill
  }

  public func toggleVideoScalingMode() {
    if moviePlayer.scalingMode != .AspectFill {
      fillVideo()
    } else {
      fitVideo()
    }
  }

  // MARK: Social

  public func shareContent() {
    if let items = self.shareItems as [AnyObject]? {
      moviePlayer.pause()
      let shareVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
      shareVC.excludedActivityTypes =  [
        UIActivityTypePostToWeibo,
        UIActivityTypeCopyToPasteboard,
        UIActivityTypeAssignToContact,
        UIActivityTypeSaveToCameraRoll,
        UIActivityTypePostToFlickr,
        UIActivityTypePostToVimeo,
        UIActivityTypePostToTencentWeibo,
        UIActivityTypeAirDrop
      ]
      self.presentViewController(shareVC, animated: true, completion: nil)
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
      // FIXME: Timed overlay mechanism and constraints.
      if let presentationTime = presentationTime, showDuration = showDuration {
        timedOverlays.append(["vc": overlayVC, "start": presentationTime, "duration": showDuration])
      } else {
        addChildViewController(overlayVC)
        overlayVC.view.clipsToBounds = true
        UIView.animateWithDuration(0.5, animations: {
          self.controlsView.overlayContainerView.addSubview(overlayVC.view)
          overlayVC.didMoveToParentViewController(self)
        })
      }
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
    for (index, overlay) in self.timedOverlays.enumerate() {
      if let
        start = overlay["start"] as? NSTimeInterval,
        duration = overlay["duration"] as? NSTimeInterval {
          if !self.moviePlayer.currentPlaybackTime.isNaN {
            let videoTime = Int(self.moviePlayer.currentPlaybackTime)
            if Int(start) == videoTime {
              if let overlayView = overlay["vc"] as? MobilePlayerOverlayViewController {
                self.showOverlayViewController(overlayView)
                let vc = ["val": index]
                NSTimer.scheduledTimerWithTimeInterval(
                  duration,
                  target: self,
                  selector: "dissmisBannerLayout:",
                  userInfo: vc,
                  repeats: false)
              }
            }
          }
      }
    }
  }

  final func dissmisBannerLayout(notification: NSNotification) {
    if let index = notification.userInfo?["val"] as? Int,
      overlayView = timedOverlays[index]["vc"] as? MobilePlayerOverlayViewController {
        self.dismissMobilePlayerOverlay(overlayView)
    }
  }
}
