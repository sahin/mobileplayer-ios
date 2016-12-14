//
//  AVPlayerItemExtension.swift
//  cinemur-lab
//
//  Created by Fong Zhou on 14/12/2016.
//  Copyright © 2016 zheck. All rights reserved.
//

import UIKit

import AVKit
import AVFoundation

extension AVPlayerItem {

    func loadedDuration() -> Double {
        guard let lastRangeValue = self.loadedTimeRanges.first as? CMTimeRange else { return 0 }

        return lastRangeValue.duration.seconds
    }

}
