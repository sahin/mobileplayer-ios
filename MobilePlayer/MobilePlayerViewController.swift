//
//  MobilePlayerViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MediaPlayer

private var globalConfiguration = MobilePlayerConfig()

public class MobilePlayerViewController: MPMoviePlayerViewController {
  // MARK: - Properties
  // MARK: Delegation
  public var delegate: MobilePlayerViewControllerDelegate?
  // MARK: Player State
  public enum State {
    case Buffering, Idle, Complete, Paused, Playing, Error, Loading, Stalled, Unknown, SeekingBackward, SeekingForward
  }
  public private(set) var previousState: State = .Unknown
  public private(set) var state: State = .Unknown {
    didSet(oldValue) {
      previousState = oldValue
    }
  }
  // MARK: Player Configuration
  public class var globalConfig: MobilePlayerConfig { return globalConfiguration }
  public var config: MobilePlayerConfig
  // MARK: Mapped Properties
  public override var title: String? {
    didSet {
      controlsView.titleLabel.text = title
    }
  }
  // MARK: Subviews
  private let controlsView: MobilePlayerControlsView
  // MARK: Overlays
  public var overlayController = MobilePlayerOverlayViewController()
  public var isShowOverlay = false
  public var timedOverlays = [[String: AnyObject]]()
  // MARK: Sharing
  private var shareItems = [AnyObject]?()
  // MARK: Other Properties
  private var previousStatusBarHiddenValue: Bool!
  private var previousStatusBarStyle: UIStatusBarStyle!
  private var isFirstPlay = true
  private var isFirstPlayPreRoll = true
  private var bufferValue: NSTimeInterval?
  private var wasPlayingBeforeTimeShift = false
  private var playbackTimeInterfaceUpdateTimer: NSTimer?
  private var hideControlsTimer: NSTimer?
  private var updateBufferInterfaceTimer: NSTimer?
  private var updateTimeSliderViewInterfaceTimer: NSTimer?
  private var updateTimeLabelInterfaceTimer: NSTimer?
  private var currentVideoURL = NSURL()

  // MARK: - Initialization
  public init(contentURL: NSURL, configFileURL: NSURL? = nil, shareItems: [AnyObject]? = nil) {
    if let configFileURL = configFileURL {
      config = SkinParser.parseConfigFromURL(configFileURL) ?? globalConfiguration
    } else {
      config = globalConfiguration
    }
    controlsView = MobilePlayerControlsView(config: config)
    if let items = shareItems as [AnyObject]? {
      self.shareItems = items
    }
    super.init(contentURL: contentURL)
    if contentURL.host?.rangeOfString("youtube.com") != nil {
      self.checkUrlStateWithContentURL(contentURL, urlType: URLHelper.URLType.Remote)
      Youtube.h264videosWithYoutubeURL(contentURL, completion: { videoInfo, error in
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
            if let url = NSURL(string: videoURLString) {
              self.currentVideoURL = url
            }
            self.title = videoTitle
        }
      })
      if self.config.prerollViewController == nil {
        self.moviePlayer.contentURL = currentVideoURL
      }
    } else{
      checkUrlStateWithContentURL(contentURL, urlType: URLHelper.URLType.Local)
    }
    initializeMobilePlayerViewController()
  }

  private func checkUrlStateWithContentURL(contentURL: NSURL, urlType: URLHelper.URLType) {
    URLHelper.checkURL(contentURL, urlType: urlType) { (check, error) -> Void in
      if check {
        self.state = .Loading
      }else{
        self.state = .Error
      }
    }
  }

  public required init(coder aDecoder: NSCoder) {
    fatalError("storyboards are incompatible with truth and beauty")
  }

  private func initializeMobilePlayerViewController() {
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
    controlsView.volumeButton.addTarget(
      self,
      action: "toggleVolumeControl",
      forControlEvents: .TouchUpInside)
    controlsView.timeSliderView.timeSlider.addTarget(
      self,
      action: "timeShiftDidBegin",
      forControlEvents: .TouchDown)
    controlsView.timeSliderView.timeSlider.addTarget(
      self,
      action: "goToTimeSliderTime",
      forControlEvents: .ValueChanged)
    controlsView.timeSliderView.timeSlider.addTarget(
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
    updateBufferInterfaceTimer = NSTimer.scheduledTimerWithTimeInterval(
      0.0,
      target: self,
      selector: "updateBufferInterface",
      userInfo: nil, repeats: true)
    updateTimeSliderViewInterfaceTimer = NSTimer.scheduledTimerWithTimeInterval(
      0.0,
      target: self,
      selector: "updateTimeSliderViewInterface",
      userInfo: nil, repeats: true)
    updateTimeLabelInterfaceTimer = NSTimer.scheduledTimerWithTimeInterval(
      1.0,
      target: self,
      selector: "updateTimeLabelInterface",
      userInfo: nil, repeats: true)
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

  deinit {
    playbackTimeInterfaceUpdateTimer?.invalidate()
    hideControlsTimer?.invalidate()
    updateBufferInterfaceTimer?.invalidate()
    updateTimeSliderViewInterfaceTimer?.invalidate()
    updateTimeLabelInterfaceTimer?.invalidate()
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  // MARK: - Internal Helpers
  private func doFirstPlaySetupIfNeeded() {
    if isFirstPlay {
      isFirstPlay = false
      controlsView.backgroundImageView.removeFromSuperview()
      controlsView.activityIndicatorView.stopAnimating()
      updateTimeLabel(controlsView.durationLabel, time: moviePlayer.duration)
      playbackTimeInterfaceUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(0.0,
        target: self, selector: "updatePlaybackTimeInterface", userInfo: nil, repeats: true)
      playbackTimeInterfaceUpdateTimer?.fire()
      if let firstPlayCallback = config.firstPlayCallback {
        firstPlayCallback(playerVC: self)
      }
    }
  }

  private func updateTimeSlider() {
    controlsView.timeSliderView.maximumValue = Float(moviePlayer.duration)
    controlsView.timeSliderView.value = Float(moviePlayer.currentPlaybackTime)
  }

  private func updateTimeLabel(label: UILabel, time: NSTimeInterval) {
    if time.isNaN || time == NSTimeInterval.infinity {
      return
    }
    let remainingTime = moviePlayer.duration - moviePlayer.currentPlaybackTime
    let remainingHours = UInt(remainingTime / 3600)
    let remainingMinutes = UInt((remainingTime / 60) % 60)
    let remainingSeconds = UInt(remainingTime % 60)
    var remainingTimeLabelText = NSString(
      format: "%02lu:%02lu",
      remainingMinutes,
      remainingSeconds) as String
    controlsView.remainingLabel.text = checkTimeLabelText(remainingTimeLabelText)
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

  private func resetHideControlsTimer() {
    hideControlsTimer?.invalidate()
    hideControlsTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hideControlsIfPlaying", userInfo: nil, repeats: false)
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

// MARK: - Event Handling
extension MobilePlayerViewController {

  func toggleVolumeControl() {
    controlsView.toggleVolumeView()
  }

  func togglePlay() {
    let playerState = moviePlayer.playbackState
    if playerState == .Playing || playerState == .Interrupted {
      moviePlayer.pause()
    } else {
      if isFirstPlayPreRoll {
        if let preRoll = self.config.prerollViewController {
          dismissMobilePlayerOverlay(preRoll)
          isFirstPlayPreRoll = false
        }
      }
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
    var playerState = moviePlayer.playbackState
    state = StateHelper.stateForPlayer(moviePlayer)
    controlsView.playerStateLabel.text = NSString(format: "%d-%d", state.hashValue, previousState.hashValue) as String
    updatePlaybackTimeInterface()
    if playerState == .Playing || playerState == .Interrupted {
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
          pauseVideoPlayer()
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

  final func hideControlsIfPlaying() {
    let playerState = moviePlayer.playbackState
    if playerState == .Playing || playerState == .Interrupted {
      controlsView.controlsHidden = controlsView.volumeView.hidden
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

  private func showOverlayViewController(overlayVC: MobilePlayerOverlayViewController) {
    addChildViewController(overlayVC)
    overlayVC.view.clipsToBounds = true
    UIView.animateWithDuration(0.5, animations: {
      self.controlsView.overlayContainerView.addSubview(overlayVC.view)
      overlayVC.didMoveToParentViewController(self)
    })
  }

  final func timeShiftDidBegin() {
    let playerState = moviePlayer.playbackState
    wasPlayingBeforeTimeShift = (playerState == .Playing || playerState == .Interrupted)
    moviePlayer.pause()
  }

  final func goToTimeSliderTime() {
    var timeVal = controlsView.timeSliderView.value
    moviePlayer.currentPlaybackTime = NSTimeInterval(controlsView.timeSliderView.value)
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

// MARK: - Public API
extension MobilePlayerViewController {

  public final func toggleVideoScalingMode() {
    if moviePlayer.scalingMode != .AspectFill {
      moviePlayer.scalingMode = .AspectFill
    } else {
      moviePlayer.scalingMode = .AspectFit
    }
  }

  public final func updateBufferInterface() {
    if let
      bufferCalculate = progressBarBufferPercentWithMoviePlayer(moviePlayer) as? NSTimeInterval {
      bufferValue = bufferCalculate
      if moviePlayer.duration > 0 {
        controlsView.timeSliderView.refreshBufferPercentRatio(
          bufferRatio: CGFloat(bufferCalculate),
          totalDuration: CGFloat(moviePlayer.duration))
      }
    }
  }

  public final func updateTimeSliderViewInterface(){
    controlsView.timeSliderView.refreshVideoProgressPercentRaito(
      videoRaito: CGFloat(moviePlayer.currentPlaybackTime),
      totalDuration: CGFloat(moviePlayer.duration)
    )
    controlsView.timeSliderView.refreshCustomTimeSliderPercentRatio()
  }

  public final func updatePlaybackTimeInterface() {
    updateTimeSlider()
    controlsView.setNeedsLayout()
  }

  public final func toggleControlVisibility() {
    if controlsView.controlsHidden {
      controlsView.controlsHidden = false
      resetHideControlsTimer()
    } else {
      controlsView.controlsHidden = true
      controlsView.volumeView.hidden = true
      hideControlsTimer?.invalidate()
    }
  }

  public final func shareContent() {
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

  public final func dismiss() {
    moviePlayer.stop()
    if let nc = navigationController {
      nc.popViewControllerAnimated(true)
    } else {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
}

// MARK: - Timed Overlays
extension MobilePlayerViewController {

  public final func showOverlayViewController(
    overlayVC: MobilePlayerOverlayViewController,
    startingAtTime: NSTimeInterval,
    forDuration: NSTimeInterval) {
      timedOverlays.append(["vc": overlayVC, "start": startingAtTime, "duration": forDuration])
  }

  public final func updateTimeLabelInterface(){
    updateTimeLabel(controlsView.playbackTimeLabel, time: moviePlayer.currentPlaybackTime)
    controlsView.setNeedsLayout()
    for (index,overlay) in enumerate(timedOverlays) {
      if let start = overlay["start"] as? NSTimeInterval,
        duration = overlay["duration"] as? NSTimeInterval {
          if !self.moviePlayer.currentPlaybackTime.isNaN {
            var videoTime = Int(self.moviePlayer.currentPlaybackTime)
            if Int(start) == videoTime {
              if let overlayView = overlay["vc"] as? MobilePlayerOverlayViewController {
                self.showOverlayViewController(overlayView)
                let vc = ["val": index]
                NSTimer.scheduledTimerWithTimeInterval(
                  duration, target: self, selector: "dissmisBannerLayout:", userInfo: vc, repeats: false)
              }
            }
          }
      }
    }
  }

  public func dissmisBannerLayout(notification: NSNotification) {
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
