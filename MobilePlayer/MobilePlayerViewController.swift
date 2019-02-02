//
//  MobilePlayerViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 12/02/15.
//  Copyright (c) 2015 MovieLaLa. All rights reserved.
//

import UIKit
import MediaPlayer

/// A view controller for playing media content.
open class MobilePlayerViewController: MPMoviePlayerViewController {
  // MARK: Playback State

  /// Playback state.
  public enum State {

    /// Either playback has not started or playback was stopped due to a `stop()` call or an error. When an error
    /// occurs, a corresponding `MobilePlayerDidEncounterErrorNotification` notification is posted.
    case idle

    /// The video will start playing, but sufficient data to start playback has to be loaded first.
    case buffering

    /// The video is currently playing.
    case playing

    /// The video is currently paused.
    case paused
  }

  /// The previous value of `state`. Default is `.Idle`.
  public private(set) var previousState: State = .idle

  /// Current `State` of the player. Default is `.Idle`.
  public private(set) var state: State = .idle {
    didSet {
      previousState = oldValue
    }
  }

  // MARK: Player Configuration

  // TODO: Move inside MobilePlayerConfig
  private static let playbackInterfaceUpdateInterval = 0.25

  /// The global player configuration object that is loaded by a player if none is passed for its
  /// initialization.
  public static let globalConfig = MobilePlayerConfig()

  /// The configuration object that was used to initialize the player, may point to the global player configuration
  /// object.
  public let config: MobilePlayerConfig

  // MARK: Mapped Properties

  /// A localized string that represents the video this controller manages. Setting a value will update the title label
  /// in the user interface if one exists.
  open override var title: String? {
    didSet {
      guard let titleLabel = getViewForElementWithIdentifier("title") as? Label else { return}
      titleLabel.text = title
      titleLabel.superview?.setNeedsLayout()
    }
  }

  // MARK: Private Properties
  private let controlsView: MobilePlayerControlsView
  private var previousStatusBarHiddenValue: Bool?
  private var previousStatusBarStyle: UIStatusBarStyle!
  private var isFirstPlay = true
  fileprivate var seeking = false
  fileprivate var wasPlayingBeforeSeek = false
  private var playbackInterfaceUpdateTimer: Timer?
  private var hideControlsTimer: Timer?

  // MARK: Initialization

  /// Initializes a player with content given by `contentURL`. If provided, the overlay view controllers used to
  /// initialize the player should be different instances from each other.
  ///
  /// - parameters:
  ///   - contentURL: URL of the content that will be used for playback.
  ///   - config: Player configuration. Defaults to `globalConfig`.
  ///   - prerollViewController: Pre-roll view controller. Defaults to `nil`.
  ///   - pauseOverlayViewController: Pause overlay view controller. Defaults to `nil`.
  ///   - postrollViewController: Post-roll view controller. Defaults to `nil`.
  public init(contentURL: URL,
              config: MobilePlayerConfig = MobilePlayerViewController.globalConfig,
              prerollViewController: MobilePlayerOverlayViewController? = nil,
              pauseOverlayViewController: MobilePlayerOverlayViewController? = nil,
              postrollViewController: MobilePlayerOverlayViewController? = nil) {
    self.config = config
    controlsView = MobilePlayerControlsView(config: config)
    self.prerollViewController = prerollViewController
    self.pauseOverlayViewController = pauseOverlayViewController
    self.postrollViewController = postrollViewController
    super.init(contentURL: contentURL)
    initializeMobilePlayerViewController()
  }

  /// Returns a player initialized from data in a given unarchiver. `globalConfig` is used for configuration in this
  /// case. In most cases the other intializer should be used.
  ///
  /// - parameters:
  ///   - coder: An unarchiver object.
  public required init?(coder aDecoder: NSCoder) {
    config = MobilePlayerViewController.globalConfig
    controlsView = MobilePlayerControlsView(config: config)
    self.prerollViewController = nil
    self.pauseOverlayViewController = nil
    self.postrollViewController = nil
    super.init(coder: aDecoder)
    initializeMobilePlayerViewController()
  }

  private func initializeMobilePlayerViewController() {
    view.clipsToBounds = true
    edgesForExtendedLayout = []
    moviePlayer.scalingMode = .aspectFit
    moviePlayer.controlStyle = .none
    initializeNotificationObservers()
    initializeControlsView()
    parseContentURLIfNeeded()
    if let watermarkConfig = config.watermarkConfig {
      showOverlayViewController(WatermarkViewController(config: watermarkConfig))
    }
  }

  private func initializeNotificationObservers() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(
      forName: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange,
      object: moviePlayer,
      queue: OperationQueue.main) { [weak self] notification in
        guard let slf = self else {
          return
        }
        slf.handleMoviePlayerPlaybackStateDidChangeNotification()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MobilePlayerStateDidChangeNotification), object: slf)
    }
    notificationCenter.removeObserver(
      self,
      name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish,
      object: moviePlayer)
    notificationCenter.addObserver(
      forName: NSNotification.Name.MPMoviePlayerPlaybackDidFinish,
      object: moviePlayer,
      queue: OperationQueue.main) { [weak self] notification in
        guard let slf = self else {
          return
        }
        if
          let userInfo = notification.userInfo as? [String: AnyObject],
          let error = userInfo["error"] as? NSError {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: MobilePlayerDidEncounterErrorNotification), object: self, userInfo: [MobilePlayerErrorUserInfoKey: error])
        }
        if let postrollVC = slf.postrollViewController {
          slf.prerollViewController?.dismiss()
          slf.pauseOverlayViewController?.dismiss()
          slf.showOverlayViewController(postrollVC)
        }
    }
  }

  private func initializeControlsView() {
    (getViewForElementWithIdentifier("playback") as? Slider)?.delegate = self

    (getViewForElementWithIdentifier("close") as? Button)?.addCallback(
      callback: { [weak self] in
        guard let slf = self else {
          return
        }
        if let navigationController = slf.navigationController {
          navigationController.popViewController(animated: true)
        } else if let presentingController = slf.presentingViewController {
          presentingController.dismissMoviePlayerViewControllerAnimated()
        }
      },
      forControlEvents: .touchUpInside)

    if let actionButton = getViewForElementWithIdentifier("action") as? Button {
      actionButton.isHidden = true // Initially hidden until 1 or more `activityItems` are set.
      actionButton.addCallback(
        callback: { [weak self] in
          guard let slf = self else {
            return
          }
          slf.showContentActions(sourceView: actionButton)
        },
        forControlEvents: .touchUpInside)
    }

    (getViewForElementWithIdentifier("play") as? ToggleButton)?.addCallback(
      callback: { [weak self] in
        guard let slf = self else {
          return
        }
        slf.resetHideControlsTimer()
        slf.state == .playing ? slf.pause() : slf.play()
      },
      forControlEvents: .touchUpInside)

    initializeControlsViewTapRecognizers()
  }

  private func initializeControlsViewTapRecognizers() {
    let singleTapRecognizer = UITapGestureRecognizer { [weak self] in self?.handleContentTap() }
    singleTapRecognizer.numberOfTapsRequired = 1
    controlsView.addGestureRecognizer(singleTapRecognizer)
    let doubleTapRecognizer = UITapGestureRecognizer { [weak self] in self?.handleContentDoubleTap() }
    doubleTapRecognizer.numberOfTapsRequired = 2
    controlsView.addGestureRecognizer(doubleTapRecognizer)
    singleTapRecognizer.require(toFail: doubleTapRecognizer)
  }

  // MARK: View Controller Lifecycle

  /// Called after the controller's view is loaded into memory.
  ///
  /// This method is called after the view controller has loaded its view hierarchy into memory. This method is
  /// called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the
  /// `loadView` method. You usually override this method to perform additional initialization on views that were
  /// loaded from nib files.
  ///
  /// If you override this method make sure you call super's implementation.
  open override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(controlsView)
    playbackInterfaceUpdateTimer = Timer.scheduledTimerWithTimeInterval(
      ti: MobilePlayerViewController.playbackInterfaceUpdateInterval,
      callback: { [weak self] in self?.updatePlaybackInterface() },
      repeats: true)
    if let prerollViewController = prerollViewController {
      shouldAutoplay = false
      showOverlayViewController(prerollViewController)
    }
  }

  /// Called to notify the view controller that its view is about to layout its subviews.
  ///
  /// When a view's bounds change, the view adjusts the position of its subviews. Your view controller can override
  /// this method to make changes before the view lays out its subviews.
  ///
  /// The default implementation of this method sets the frame of the controls view.
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    controlsView.frame = view.bounds
  }

  /// Notifies the view controller that its view is about to be added to a view hierarchy.
  ///
  /// If `true`, the view is being added to the window using an animation.
  ///
  /// The default implementation of this method hides the status bar.
  ///
  /// - parameters:
  ///  - animated: If `true`, the view is being added to the window using an animation.
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // Force hide status bar.
    previousStatusBarHiddenValue = UIApplication.shared.isStatusBarHidden
    UIApplication.shared.isStatusBarHidden = true
    setNeedsStatusBarAppearanceUpdate()
  }

  /// Notifies the view controller that its view is about to be removed from a view hierarchy.
  ///
  /// If `true`, the disappearance of the view is being animated.
  ///
  /// The default implementation of this method stops playback and restores status bar appearance to how it was before
  /// the view appeared.
  ///
  /// - parameters:
  ///  - animated: If `true`, the disappearance of the view is being animated.
  open override func viewWillDisappear(_ animated: Bool) {
    // Restore status bar appearance.
    if let previousStatusBarHidden = previousStatusBarHiddenValue {
        UIApplication.shared.isStatusBarHidden = previousStatusBarHidden
        setNeedsStatusBarAppearanceUpdate()
    }
    super.viewWillDisappear(animated)
    stop()
  }

  // MARK: Deinitialization

  deinit {
    playbackInterfaceUpdateTimer?.invalidate()
    hideControlsTimer?.invalidate()
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: Playback

  /// Indicates whether content should begin playback automatically.
  ///
  /// The default value of this property is true. This property determines whether the playback of network-based
  /// content begins automatically when there is enough buffered data to ensure uninterrupted playback.
  public var shouldAutoplay: Bool {
    get {
      return moviePlayer.shouldAutoplay
    }
    set {
      moviePlayer.shouldAutoplay = newValue
    }
  }

  /// Initiates playback of current content.
  ///
  /// Starting playback causes dismiss to be called on prerollViewController, pauseOverlayViewController
  /// and postrollViewController.
  public func play() {
    moviePlayer.play()
  }

  /// Pauses playback of current content.
  ///
  /// Pausing playback causes pauseOverlayViewController to be shown.
  public func pause() {
    moviePlayer.pause()
  }

  /// Ends playback of current content.
  public func stop() {
    moviePlayer.stop()
  }

  // MARK: Video Rendering

  /// Makes playback content fit into player's view.
  public func fitVideo() {
    moviePlayer.scalingMode = .aspectFit
  }

  /// Makes playback content fill player's view.
  public func fillVideo() {
    moviePlayer.scalingMode = .aspectFill
  }

  /// Makes playback content switch between fill/fit modes when content area is double tapped. Overriding this method
  /// is recommended if you want to change this behavior.
  public func handleContentDoubleTap() {
    // TODO: videoScalingMode property and enum.
    moviePlayer.scalingMode != .aspectFill ? fillVideo() : fitVideo()
  }

  // MARK: Social

  /// An array of activity items that will be used for presenting a `UIActivityViewController` when the action
  /// button is pressed (if it exists). If content is playing, it is paused automatically at presentation and will
  /// continue after the controller is dismissed. Override `showContentActions()` if you want to change the button's
  /// behavior.
  public var activityItems: [Any]? {
    didSet {
      let isEmpty = activityItems?.isEmpty ?? true
      getViewForElementWithIdentifier("action")?.isHidden = isEmpty
    }
  }
    
  /// An array of activity types that will be excluded when presenting a `UIActivityViewController`
  public var excludedActivityTypes: [UIActivity.ActivityType]? = [
      .assignToContact,
      .saveToCameraRoll,
      .postToVimeo,
      .airDrop
  ]

  /// Method that is called when a control interface button with identifier "action" is tapped. Presents a
  /// `UIActivityViewController` with `activityItems` set as its activity items. If content is playing, it is paused
  /// automatically at presentation and will continue after the controller is dismissed. Overriding this method is
  /// recommended if you want to change this behavior.
  ///
  /// parameters:
  ///   - sourceView: On iPads the activity view controller is presented as a popover and a source view needs to
  ///     provided or a crash will occur.
  open func showContentActions(sourceView: UIView? = nil) {
    guard let activityItems = activityItems, !activityItems.isEmpty else { return }
    let wasPlaying = (state == .playing)
    moviePlayer.pause()
    let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    activityVC.excludedActivityTypes =  excludedActivityTypes
    activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
      if wasPlaying {
        self.moviePlayer.play()
      }
    }
    if let sourceView = sourceView {
      activityVC.popoverPresentationController?.sourceView = controlsView
      activityVC.popoverPresentationController?.sourceRect = sourceView.convert(
        sourceView.bounds,
        to: controlsView)
    }
    present(activityVC, animated: true, completion: nil)
  }

  // MARK: Controls

  /// Indicates if player controls are hidden. Setting its value will animate controls in or out.
  public var controlsHidden: Bool {
    get {
      return controlsView.controlsHidden
    }
    set {
      newValue ? hideControlsTimer?.invalidate() : resetHideControlsTimer()
      controlsView.controlsHidden = newValue
    }
  }

  /// Returns the view associated with given player control element identifier.
  ///
  /// - parameters:
  ///   - identifier: Element identifier.
  /// - returns: View or nil if element is not found.
  public func getViewForElementWithIdentifier(_ identifier: String) -> UIView? {
    if let view = controlsView.topBar.getViewForElementWithIdentifier(identifier: identifier) {
      return view
    }
    return controlsView.bottomBar.getViewForElementWithIdentifier(identifier: identifier)
  }

  /// Hides/shows controls when content area is tapped once. Overriding this method is recommended if you want to change
  /// this behavior.
  public func handleContentTap() {
    controlsHidden = !controlsHidden
  }

  // MARK: Overlays

  private var timedOverlays = [TimedOverlayInfo]()

  /// The `MobilePlayerOverlayViewController` that will be presented on top of the player content at start. If a
  /// controller is set then content will not start playing automatically even if `shouldAutoplay` is `true`. The
  /// controller will dismiss if user presses the play button or `play()` is called.
  public let prerollViewController: MobilePlayerOverlayViewController?

  /// The `MobilePlayerOverlayViewController` that will be presented on top of the player content whenever playback is
  /// paused. Does not include pauses in playback due to buffering.
  public let pauseOverlayViewController: MobilePlayerOverlayViewController?

  /// The `MobilePlayerOverlayViewController` that will be presented on top of the player content when playback
  /// finishes.
  public let postrollViewController: MobilePlayerOverlayViewController?

  /// Presents given overlay view controller on top of the player content immediately, or at a given content time for
  /// a given duration. Both starting time and duration parameters should be provided to show a timed overlay.
  ///
  /// - parameters:
  ///   - overlayViewController: The `MobilePlayerOverlayViewController` to be presented.
  ///   - startingAtTime: Content time the overlay will be presented at.
  ///   - forDuration: Added on top of `startingAtTime` to calculate the content time when overlay will be dismissed.
  public func showOverlayViewController(_ overlayViewController: MobilePlayerOverlayViewController,
                                        startingAtTime presentationTime: TimeInterval? = nil,
                                        forDuration showDuration: TimeInterval? = nil) {
    if let presentationTime = presentationTime, let showDuration = showDuration {
      timedOverlays.append(TimedOverlayInfo(
        startTime: presentationTime,
        duration: showDuration,
        overlay: overlayViewController))
    } else if overlayViewController.parent == nil {
      overlayViewController.delegate = self
      addChild(overlayViewController)
      overlayViewController.view.clipsToBounds = true
      overlayViewController.view.frame = controlsView.overlayContainerView.bounds
      controlsView.overlayContainerView.addSubview(overlayViewController.view)
      overlayViewController.didMove(toParent: self)
    }
  }

  /// Dismisses all currently presented overlay view controllers and clears any timed overlays.
  public func clearOverlays() {
    for timedOverlayInfo in timedOverlays {
      timedOverlayInfo.overlay.dismiss()
    }
    timedOverlays.removeAll()
    for childViewController in children {
      if childViewController is WatermarkViewController { continue }
      (childViewController as? MobilePlayerOverlayViewController)?.dismiss()
    }
  }

  // MARK: Private Methods

  private func parseContentURLIfNeeded() {
    guard let youtubeID = YoutubeParser.youtubeIDFromURL(url: moviePlayer.contentURL) else { return }
    YoutubeParser.h264videosWithYoutubeID(youtubeID) { videoInfo, error in
      if let error = error {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MobilePlayerDidEncounterErrorNotification), object: self, userInfo: [MobilePlayerErrorUserInfoKey: error])
      }
      guard let videoInfo = videoInfo else { return }
      self.title = self.title ?? videoInfo.title
      if
        let previewImageURLString = videoInfo.previewImageURL,
        let previewImageURL = URL(string: previewImageURLString) {
          URLSession.shared.dataTask(with: previewImageURL) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
              self.controlsView.previewImageView.image = UIImage(data: data)
            }
          }
      }
      if let videoURL = videoInfo.videoURL {
        self.moviePlayer.contentURL = URL(string: videoURL)
      }
    }
  }

  private func doFirstPlaySetupIfNeeded() {
    if isFirstPlay {
      isFirstPlay = false
      controlsView.previewImageView.isHidden = true
      controlsView.activityIndicatorView.stopAnimating()
    }
  }

  private func updatePlaybackInterface() {
    if let playbackSlider = getViewForElementWithIdentifier("playback") as? Slider {
      playbackSlider.maximumValue = Float(moviePlayer.duration.isNormal ? moviePlayer.duration : 0)
      if !seeking {
        let sliderValue = Float(moviePlayer.currentPlaybackTime.isNormal ? moviePlayer.currentPlaybackTime : 0)
        playbackSlider.setValue(value: sliderValue, animatedForDuration: MobilePlayerViewController.playbackInterfaceUpdateInterval)
      }
      let availableValue = Float(moviePlayer.playableDuration.isNormal ? moviePlayer.playableDuration : 0)
      playbackSlider.setAvailableValue(
        availableValue: availableValue,
        animatedForDuration: MobilePlayerViewController.playbackInterfaceUpdateInterval)
    }
    if let currentTimeLabel = getViewForElementWithIdentifier("currentTime") as? Label {
      currentTimeLabel.text = textForPlaybackTime(time: moviePlayer.currentPlaybackTime)
      currentTimeLabel.superview?.setNeedsLayout()
    }
    if let remainingTimeLabel = getViewForElementWithIdentifier("remainingTime") as? Label {
      remainingTimeLabel.text = "-\(textForPlaybackTime(time: moviePlayer.duration - moviePlayer.currentPlaybackTime))"
      remainingTimeLabel.superview?.setNeedsLayout()
    }
    if let durationLabel = getViewForElementWithIdentifier("duration") as? Label {
      durationLabel.text = textForPlaybackTime(time: moviePlayer.duration)
      durationLabel.superview?.setNeedsLayout()
    }
    updateShownTimedOverlays()
  }

  private func textForPlaybackTime(time: TimeInterval) -> String {
    if !time.isNormal {
      return "00:00"
    }
    let hours = Int(floor(time / 3600))
    let minutes = Int(floor((time / 60).truncatingRemainder(dividingBy: 60)))
    let seconds = Int(floor(time.truncatingRemainder(dividingBy: 60)))
    let minutesAndSeconds = NSString(format: "%02d:%02d", minutes, seconds) as String
    if hours > 0 {
      return NSString(format: "%02d:%@", hours, minutesAndSeconds) as String
    } else {
      return minutesAndSeconds
    }
  }

  private func resetHideControlsTimer() {
    hideControlsTimer?.invalidate()
    hideControlsTimer = Timer.scheduledTimerWithTimeInterval(
      ti: 3,
      callback: {
        self.controlsView.controlsHidden = (self.state == .playing)
      },
      repeats: false)
  }

  private func handleMoviePlayerPlaybackStateDidChangeNotification() {
    state = StateHelper.calculateStateUsing(previousState: previousState, andPlaybackState: moviePlayer.playbackState)
    let playButton = getViewForElementWithIdentifier("play") as? ToggleButton
    if state == .playing {
      doFirstPlaySetupIfNeeded()
      playButton?.toggled = true
      if !controlsView.controlsHidden {
        resetHideControlsTimer()
      }
      prerollViewController?.dismiss()
      pauseOverlayViewController?.dismiss()
      postrollViewController?.dismiss()
    } else {
      playButton?.toggled = false
      hideControlsTimer?.invalidate()
      controlsView.controlsHidden = false
      if let pauseOverlayViewController = pauseOverlayViewController, (state == .paused && !seeking) {
        showOverlayViewController(pauseOverlayViewController)
      }
    }
  }

  private func updateShownTimedOverlays() {
    let currentTime = self.moviePlayer.currentPlaybackTime
    if !currentTime.isNormal {
      return
    }
    DispatchQueue.global().async {
      for timedOverlayInfo in self.timedOverlays {
        if timedOverlayInfo.startTime <= currentTime && currentTime <= timedOverlayInfo.startTime + timedOverlayInfo.duration {
          if timedOverlayInfo.overlay.parent == nil {
            DispatchQueue.main.async {
              self.showOverlayViewController(timedOverlayInfo.overlay)
            }
          }
        } else if timedOverlayInfo.overlay.parent != nil {
          DispatchQueue.main.async {
            timedOverlayInfo.overlay.dismiss()
          }
        }
      }
    }
  }
}

// MARK: - MobilePlayerOverlayViewControllerDelegate
extension MobilePlayerViewController: MobilePlayerOverlayViewControllerDelegate {

  func dismiss(mobilePlayerOverlayViewController overlayViewController: MobilePlayerOverlayViewController) {
    overlayViewController.willMove(toParent: nil)
    overlayViewController.view.removeFromSuperview()
    overlayViewController.removeFromParent()
    if overlayViewController == prerollViewController {
      play()
    }
  }
}

// MARK: - TimeSliderDelegate
extension MobilePlayerViewController: SliderDelegate {

  func sliderThumbPanDidBegin(slider: Slider) {
    seeking = true
    wasPlayingBeforeSeek = (state == .playing)
    pause()
  }

  func sliderThumbDidPan(slider: Slider) {}

  func sliderThumbPanDidEnd(slider: Slider) {
    seeking = false
    moviePlayer.currentPlaybackTime = TimeInterval(slider.value)
    if wasPlayingBeforeSeek {
      play()
    }
  }
}

