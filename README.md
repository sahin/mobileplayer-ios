 MobilePlayer [![CocoaPods](https://img.shields.io/cocoapods/p/MobilePlayer.svg?style=flat)](https://cocoapods.org/pods/MobilePlayer)
-----

[![Number of Tests](https://img.shields.io/badge/Number%20of%20Tests-100+-brightgreen.svg)](https://github.com/mobileplayer/mobileplayer-ios)
[![Dependencies](https://img.shields.io/badge/dependencies-none-brightgreen.svg)](https://github.com/mobileplayer/mobileplayer-ios)
[![Ready](https://badge.waffle.io/mobileplayer/mobileplayer-ios.png?label=Ready&title=Ready)](https://waffle.io/mobileplayer/mobileplayer-ios)
[![In Progress](https://badge.waffle.io/mobileplayer/mobileplayer-ios.png?label=In%20Progress&title=In%20Progress)](https://waffle.io/mobileplayer/mobileplayer-ios)
[![Post an issue](https://img.shields.io/badge/Bug%3F-Post%20an%20issue!-blue.svg)](https://waffle.io/mobileplayer/mobileplayer-ios)

[![StackOverflow](https://img.shields.io/badge/StackOverflow-Ask%20a%20question!-blue.svg)](http://stackoverflow.com/questions/ask?tags=mobile player+ios+swift+video player) 
[![Join the chat at https://gitter.im/mobileplayer/mobileplayer-ios](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/mobileplayer/mobileplayer-ios?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A powerful and completely customizable media player for iOS.

# Table of Contents

1. [Installation](#installation)
2. [Usage](#usage)
3. [Documentation](#documentation)
4. [Software License](#software-license)

# Installation

There are various ways you can get started with using MobilePlayer in your projects.

### [Cocoapods](https://github.com/CocoaPods/CocoaPods)

Add the following line in your `Podfile`.

```
pod "MobilePlayer"
```

### [Carthage](https://github.com/Carthage/Carthage#installing-carthage)

Add the following line to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).

```
github "mobileplayer/mobileplayer-ios"
```

### Git Submodule

Open the Terminal app and `cd` to your project directory. Then run

```
git submodule add git@github.com:mobileplayer/mobileplayer-ios.git
```

This should create a folder named MobilePlayer inside your project directory. After that, drag and drop MobilePlayer/MobilePlayer.xcodeproj into your project in Xcode and add the MobilePlayer.framework in the Embedded Binaries section of your target settings under the General tab.

# Usage

If you were previously using MPMoviePlayerViewController, changing

```swift
let playerVC = MPMoviePlayerViewController(contentURL: videoURL)
```

to

```swift
let playerVC = MobilePlayerViewController(contentURL: videoURL)
```

is enough. Make sure you don't forget to

```swift
import MobilePlayer
```

## Customizing the Player

In most cases though you would want to customize the player. You can do this by creating a configuration .json file or programmatically.

### Configuration File

Coming soon.

### Programmatic Configuration

Coming soon.

# Documentation

The entire documentation for the library can be found [here](https://htmlpreview.github.io/?https://github.com/movielala/mobileplayer-ios/blob/master/Documentation/index.html).

# Software License
The use of the MobilePlayer open source edition is governed by a [Creative Commons license](http://creativecommons.org/licenses/by-nc-sa/3.0/). You can use, modify, copy, and distribute this edition as long as it’s for non-commercial use, you provide attribution, and share under a similar license.
http://mobileplayer.io/license/
