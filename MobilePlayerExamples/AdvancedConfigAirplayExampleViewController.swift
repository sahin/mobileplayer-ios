//
//  AdvancedConfigAirplayExampleViewController.swift
//  MobilePlayer
//
//  Created by Maca on 3/10/17.
//  Copyright © 2017 MovieLaLa. All rights reserved.
//

import UIKit
import MobilePlayer

class AdvancedConfigAirplayExampleViewController: ExampleViewController {
    
    override init() {
        super.init()
        title = "Advanced w/Airplay Configuration"
        codeImageView.image = UIImage(named: "AdvancedConfigExampleCode")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func showButtonDidGetTapped() {
        let bundle = Bundle.main
        let config = MobilePlayerConfig(fileURL: bundle.url(
            forResource: "Airplay",
            withExtension: "json")!)
        let playerVC = MobilePlayerViewController(
            contentURL: videoURL,
            config: config)
        playerVC.title = videoTitle
        playerVC.activityItems = [videoURL]
        presentMoviePlayerViewControllerAnimated(playerVC)
    }
}

