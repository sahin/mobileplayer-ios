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
  func didPressButton(button: UIButton, identifier: String)
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
    didSet(oldValue) {
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
      controlsView.titleLabel.text = title
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

  public init(contentURL: NSURL, configFileURL: NSURL? = nil, shareItems: [AnyObject]? = nil) {
    if let configFileURL = configFileURL {
      config = SkinParser.parseConfigFromURL(configFileURL) ?? MobilePlayerViewController.globalConfig
    } else {
      config = MobilePlayerViewController.globalConfig
    }
    controlsView = MobilePlayerControlsView(config: config)
    super.init(contentURL: contentURL)
    self.shareItems = shareItems
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
    }
    notificationCenter.removeObserver(
      self,
      name: MPMoviePlayerPlaybackDidFinishNotification,
      object: moviePlayer)
    notificationCenter.addObserverForName(
      MPMoviePlayerPlaybackDidFinishNotification,
      object: moviePlayer,
      queue: NSOperationQueue.mainQueue()) { notification in
        self.showPostrollOrDismissAtVideoEnd()
    }
  }

  private func initializeControlsView() {
    controlsView.timeSlider.delegate = self
    controlsView.closeButton.addCallback(dismiss, forControlEvents: .TouchUpInside)
    controlsView.shareButton.addCallback(shareContent, forControlEvents: .TouchUpInside)
    controlsView.playButton.addCallback(togglePlayback, forControlEvents: .TouchUpInside)
    controlsView.volumeButton.addCallback(controlsView.toggleVolumeView, forControlEvents: .TouchUpInside)
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
      callback: {
        self.controlsView.timeSlider.maximumValue = self.moviePlayer.duration.isNormal ? self.moviePlayer.duration : 0
        if !self.seeking {
          let sliderValue = self.moviePlayer.currentPlaybackTime.isNormal ? self.moviePlayer.currentPlaybackTime : 0
          self.controlsView.timeSlider.setValue(
            sliderValue,
            animatedForDuration: MobilePlayerViewController.playbackInterfaceUpdateInterval)
        }
        let bufferValue = self.moviePlayer.playableDuration.isNormal ? self.moviePlayer.playableDuration : 0
        self.controlsView.timeSlider.setBufferValue(
          bufferValue,
          animatedForDuration: MobilePlayerViewController.playbackInterfaceUpdateInterval)
        self.updateTimeLabel(self.controlsView.playbackTimeLabel, time: self.moviePlayer.currentPlaybackTime)
        self.updateShownTimedOverlays()
      },
      repeats: true)
    if let preRollVC = self.config.prerollViewController {
      showOverlayViewController(preRollVC)
    }
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
    controlsView.updateConstraintsWithLayout(view.bounds)
    //controlsView.frame = view.bounds
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
    if let youtubeID = YoutubeParser.youtubeIDFromURL(moviePlayer.contentURL) {
      YoutubeParser.h264videosWithYoutubeID(youtubeID, completion: { videoInfo, error in
        if let error = error {
          // TODO: Delegate the error.
        } else {
          if self.title == nil {
            self.title = videoInfo.title
          }
          if let
            previewImageURLString = videoInfo.previewImageURL,
            previewImageURL = NSURL(string: previewImageURLString) {
              NSURLSession.sharedSession().dataTaskWithURL(previewImageURL) { data, response, error in
                dispatch_async(dispatch_get_main_queue()) {
                  self.controlsView.backgroundImageView.image = UIImage(data: data)
                }
              }.resume()
          }
          if let videoURL = videoInfo.videoURL {
            self.moviePlayer.contentURL = NSURL(string: videoURL)
          }
        }
      })
    }
  }

  private func doFirstPlaySetupIfNeeded() {
    if isFirstPlay {
      isFirstPlay = false
      controlsView.backgroundImageView.removeFromSuperview()
      controlsView.activityIndicatorView.stopAnimating()
      updateTimeLabel(controlsView.durationLabel, time: moviePlayer.duration)
      if let firstPlayCallback = config.firstPlayCallback {
        firstPlayCallback(playerVC: self)
      }
    }
  }

  private func updateTimeLabel(label: UILabel, time: NSTimeInterval) {
    if !time.isNormal {
      label.text = "-:-"
      return
    }
    // FIXME: Remaining time calculation and remainingLabel.text assignment does not belong here.
    let remainingTime = moviePlayer.duration - moviePlayer.currentPlaybackTime
    let remainingHours = UInt(remainingTime / 3600)
    let remainingMinutes = UInt((remainingTime / 60) % 60)
    let remainingSeconds = UInt(remainingTime % 60)
    let remainingTimeLabelText = NSString(
      format: "%02lu:%02lu",
      remainingMinutes,
      remainingSeconds) as String
    controlsView.remainingLabel.text = remainingTimeLabelText
    let hours = UInt(time / 3600)
    let minutes = UInt((time / 60) % 60)
    let seconds = UInt(time % 60)
    let timeLabelText = NSString(format: "%02lu:%02lu", minutes, seconds) as String
    label.text = timeLabelText
    if hours > 0 {
      label.text = NSString(format: "%02lu:%@", hours, label.text!) as String
    }
  }

  private func resetHideControlsTimer() {
    hideControlsTimer?.invalidate()
    hideControlsTimer = NSTimer.scheduledTimerWithTimeInterval(
      2,
      callback: {
        self.controlsView.controlsHidden = (self.state == .Playing && self.controlsView.volumeView.hidden)
      },
      repeats: false)
  }

  final func handleMoviePlayerPlaybackStateDidChangeNotification() {
    state = StateHelper.calculateStateUsing(previousState, andPlaybackState: moviePlayer.playbackState)
    controlsView.playerStateLabel.text = NSString(format: "%d-%d", state.hashValue, previousState.hashValue) as String
    if state == .Playing {
      doFirstPlaySetupIfNeeded()
      controlsView.playButton.setImage(config.controlbarConfig.pauseButtonImage, forState: .Normal)
      controlsView.playButton.tintColor = config.controlbarConfig.pauseButtonTintColor
      controlsView.playButton.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
      if !controlsView.controlsHidden {
        resetHideControlsTimer()
      }
      if let pauseViewController = config.pauseViewController {
        dismissMobilePlayerOverlay(pauseViewController)
      }
      if let preRollVC = self.config.prerollViewController {
        if isFirstPlayPreRoll {
          pause()
          controlsView.playButton.setImage(
            config.controlbarConfig.playButtonImage,
            forState: .Normal
          )
          controlsView.playButton.tintColor = config.controlbarConfig.playButtonTintColor
          controlsView.playButton.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        }
      }
    } else {
      controlsView.playButton.setImage(config.controlbarConfig.playButtonImage, forState: .Normal)
      controlsView.playButton.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
      controlsView.playButton.tintColor = config.controlbarConfig.playButtonTintColor
      hideControlsTimer?.invalidate()
      controlsView.controlsHidden = false
      if let pauseViewController = config.pauseViewController {
        addChildViewController(pauseViewController)
        controlsView.overlayContainerView.addSubview(pauseViewController.view)
        pauseViewController.didMoveToParentViewController(self)
        pauseViewController.delegate = self
      }
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
extension MobilePlayerViewController: TimeSliderDelegate {

  func timeSliderSeekDidBegin(timeSlider: TimeSlider) {
    seeking = true
    wasPlayingBeforeSeek = (state == .Playing)
    moviePlayer.pause()
  }

  func timeSliderDidSeek(timeSlider: TimeSlider) {}

  func timeSliderSeekDidEnd(timeSlider: TimeSlider) {
    seeking = false
    moviePlayer.currentPlaybackTime = timeSlider.value
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

  // MARK: Overlays

  public func showOverlayViewController(
    overlayVC: MobilePlayerOverlayViewController,
    startingAtTime presentationTime: NSTimeInterval? = nil,
    forDuration showDuration: NSTimeInterval? = nil) {
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

  // MARK: - Custom Button Delegate

  func customButtonAction(button: UIButton) {
    if let identifiers = button.accessibilityElements,
      let identifier = identifiers[0] as? String  {
        delegate?.didPressButton(button, identifier: identifier)
    }
  }
}

// MARK: - UIContentContainer
extension MobilePlayerViewController {

  override public func viewWillTransitionToSize(
    size: CGSize,
    withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
      controlsView.updateConstraintsWithLayout(CGRect(x: 0, y: 0, width: size.width, height: size.height))
  }
}
