![logo](http://i.imgur.com/W9QtXEp.png)

MobilePlayer [![CocoaPods](https://img.shields.io/cocoapods/p/MobilePlayer.svg?style=flat)](https://cocoapods.org/pods/MobilePlayer)
==================
[![codebeat badge](https://codebeat.co/badges/d9492bce-7a4b-4221-b7e0-9b5abf6dda6a)](https://codebeat.co/projects/github-com-mobileplayer-mobileplayer-ios)
[![CocoaPods](http://img.shields.io/cocoapods/v/MobilePlayer.svg?style=flat)](http://cocoapods.org/?q=MobilePlayer)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Dependencies](https://img.shields.io/badge/dependencies-none-brightgreen.svg)](https://github.com/mobileplayer/mobileplayer-ios)
[![Ready](https://badge.waffle.io/mobileplayer/mobileplayer-ios.png?label=Ready&title=Ready)](https://waffle.io/mobileplayer/mobileplayer-ios)
[![StackOverflow](https://img.shields.io/badge/StackOverflow-Ask%20a%20question!-blue.svg)](http://stackoverflow.com/questions/ask?tags=mobile player+ios+swift+video player)
[![Join the chat at https://gitter.im/mobileplayer/mobileplayer-ios](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/mobileplayer/mobileplayer-ios?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A powerful and completely customizable media player for iOS.

![introduction](http://imgur.com/uDq19mw.gif)

Table of Contents
==================
1. [Features](#features)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Customization](#customization)
  - [Skinning](#skinning)
  - [Showing overlays](#showing-overlays)
  - [Showing timed overlays](#showing-timed-overlays)
  - [Pre-roll](#pre-roll)
  - [Pause overlay](#pause-overlay)
  - [Post-roll](#post-roll)
6. [Examples](#examples)
7. [Documentation](#documentation)
8. [License](#license)

Features
==================
- Branding
  - Flexible skinning. Add a watermark, add/remove/move/resize interface elements, change their appearances and much more.
  - Easily set up A/B tests. You can manage multiple player skins and configurations. Player view controllers can load configuration data from a local JSON file or remote JSON data. You also have the option to initialize and pass configuration objects programmatically, which allows for greater flexibility.
- Engagement
  - Comes with a built-in share button.
  - Standard sharing behavior can easily be modified.
  - Show any view controller as pre-roll or post-roll content.
  - Powerful overlay system. Add any view controller as an overlay to your video. Make them permanently visible, set them to appear in defined playback time intervals, or while playback is paused.
- 100% documented.

### Future plans
- Well defined and extensive `NSNotification`s.
- Volume button and volume slider elements.
- Airplay support.
- Plugin support.
- Pre-bundled analytics plugins for various platforms.
- VAST support.
- Monetization.

Installation
==================

### [CocoaPods](https://github.com/CocoaPods/CocoaPods)
Add the following line in your `Podfile`.
```
pod "MobilePlayer"
```

### [Carthage](https://github.com/Carthage/Carthage#installing-carthage)
Add the following line to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).
```
github "mobileplayer/mobileplayer-ios"
```

Usage
==================
```swift
import MobilePlayer

let playerVC = MobilePlayerViewController(contentURL: videoURL)
playerVC.title = "Vanilla Player - \(videoTitle)"
playerVC.activityItems = [videoURL] // Check the documentation for more information.
presentMoviePlayerViewControllerAnimated(playerVC)
```
![example-plain](http://i.imgur.com/J6QpSKb.gif)

Customization
==================

**Initialize using local configuration file**
```swift
let bundle = NSBundle.mainBundle()
let config = MobilePlayerConfig(fileURL: bundle.URLForResource(
  "WatermarkedPlayer",
  withExtension: "json")!)
let playerVC = MobilePlayerViewController(
  contentURL: videoURL,
  config: config)
playerVC.title = "Watermarked Player - \(videoTitle)"
playerVC.activityItems = [videoURL]
presentMoviePlayerViewControllerAnimated(playerVC)
```

**Initialize using remote configuration data**
```swift
guard let configURL = NSURL(string: "https://goo.gl/c73ANK") else { return }
let playerVC = MobilePlayerViewController(
  contentURL: videoURL,
  config: MobilePlayerConfig(fileURL: configURL))
playerVC.title = "Watermarked Player - \(videoTitle)"
playerVC.activityItems = [videoURL]
presentMoviePlayerViewControllerAnimated(playerVC)
```

**Configuration data**
```json
{
  "watermark": {
    "image": "MovielalaLogo"
  }
}
```

**Without a configuration file URL**
```swift
let playerVC = MobilePlayerViewController(
  contentURL: videoURL,
  config: MobilePlayerConfig(
    dictionary: ["watermark": ["image": "MovielalaLogo"]]))
playerVC.title = "Watermarked Player - \(videoTitle)"
playerVC.activityItems = [videoURL]
presentMoviePlayerViewControllerAnimated(playerVC)
```

**Result**
![example-customization](http://i.imgur.com/tGodgQx.png)

### Skinning
```json
{
  "watermark": {
    "image": "MovielalaLogo",
    "position": "topRight"
  },
  "topBar": {
    "backgroundColor": ["#a60500b0", "#a60500a0"],
    "elements": [
      {
        "type": "button",
        "identifier": "close"
      },
      {
        "type": "slider",
        "identifier": "playback",
        "trackHeight": 6,
        "trackCornerRadius": 3,
        "minimumTrackTintColor": "#eee",
        "availableTrackTintColor": "#9e9b9a",
        "maximumTrackTintColor": "#cccccc",
        "thumbTintColor": "#f9f9f9",
        "thumbBorderWidth": 1,
        "thumbBorderColor": "#fff",
        "marginRight": 4
      }
    ]
  },
  "bottomBar": {
    "backgroundColor": ["#a60500a0", "#a60500b0"],
    "elements": [
      {
        "type": "label",
        "text": "Now Watching",
        "font": "Baskerville",
        "size": 12,
        "marginLeft": 8,
        "marginRight": 8
      },
      {
        "type": "label",
        "identifier": "title",
        "size": 14
      },
      {
        "type": "button",
        "identifier": "action"
      },
      {
        "type": "toggleButton",
        "identifier": "play"
      }
    ]
  }
}
```
For all available `identifier`s, check the documentation or [here](https://github.com/mobileplayer/mobileplayer-ios/blob/master/MobilePlayer/Config/ElementConfig.swift#L51). Same `identifier` value shouldn't be used more than once in a single configuration.

**Result**
![example-skinning](http://i.imgur.com/YyiYJCc.png)

**Example designs**
![example-design-skinning](http://i.imgur.com/qNDrx9T.gif)

### Showing overlays
```swift
let playerVC = MobilePlayerViewController(contentURL: videoURL)
playerVC.title = videoTitle
playerVC.activityItems = [videoURL]
presentMoviePlayerViewControllerAnimated(playerVC)
ProductStore.getProduct("1", success: { product in
  guard let product = product else { return }
  playerVC.showOverlayViewController(
    BuyOverlayViewController(product: product))
})
```
![example-overlay](http://i.imgur.com/wAtNYjE.png)

### Showing timed overlays
```swift
let playerVC = MobilePlayerViewController(contentURL: videoURL)
playerVC.title = videoTitle
playerVC.activityItems = [videoURL]
presentMoviePlayerViewControllerAnimated(playerVC)
ProductStore.getProductPlacementsForVideo(
  videoID,
  success: { productPlacements in
    guard let productPlacements = productPlacements else { return }
    for placement in productPlacements {
      ProductStore.getProduct(placement.productID, success: { product in
        guard let product = product else { return }
        playerVC.showOverlayViewController(
          BuyOverlayViewController(product: product),
          startingAtTime: placement.startTime,
          forDuration: placement.duration)
      })
    }
})
```
![example-timed-overlays](http://i.imgur.com/FuaJB7O.gif)

### Pre-roll
```swift
let playerVC = MobilePlayerViewController(
  contentURL: videoURL,
  prerollViewController: PrerollOverlayViewController())
playerVC.title = videoTitle
playerVC.activityItems = [videoURL]
presentMoviePlayerViewControllerAnimated(playerVC)
```
![example-preroll](http://i.imgur.com/oBV0HCF.png)

### Pause overlay
```swift
let playerVC = MobilePlayerViewController(
  contentURL: videoURL,
  pauseOverlayViewController: PauseOverlayViewController())
playerVC.title = videoTitle
playerVC.activityItems = [videoURL]
presentMoviePlayerViewControllerAnimated(playerVC)
```

**Result**
![example-pause-overlay](http://i.imgur.com/wfC9a7t.gif)

**Example designs**
![example-design-pause-overlay](http://i.imgur.com/ectKEwy.gif)

### Post-roll
```swift
let playerVC = MobilePlayerViewController(
  contentURL: videoURL,
  postrollViewController: PostrollOverlayViewController())
playerVC.title = videoTitle
playerVC.activityItems = [videoURL]
presentMoviePlayerViewControllerAnimated(playerVC)
```

**Result**
![example-postroll](http://i.imgur.com/Hp8NEfg.png)

**Example designs**
![example-design-postroll](http://i.imgur.com/MRVxNAt.gif)

Examples
==================
After cloning the repo, run the `MobilePlayerExamples` target to see examples for many use cases.
![examples](http://i.imgur.com/ztOPUW6.gif)

Documentation
==================
The entire documentation for the library can be found [here](https://htmlpreview.github.io/?https://github.com/movielala/mobileplayer-ios/blob/master/Documentation/index.html).

License
==================
The use of the MobilePlayer open source edition is governed by a [Creative Commons license](http://creativecommons.org/licenses/by-nc-sa/3.0/). You can use, modify, copy, and distribute this edition as long as it’s for non-commercial use, you provide attribution, and share under a similar license.
http://mobileplayer.io/license/
