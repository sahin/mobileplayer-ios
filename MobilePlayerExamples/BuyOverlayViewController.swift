//
//  BuyOverlayViewController.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 08/12/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import Foundation
import MobilePlayer
import MobilePlayerExampleStores

class BuyOverlayViewController: MobilePlayerOverlayViewController {
  private static let maxWidth = CGFloat(200)
  let containerView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
  let descriptionLabel = UILabel(frame: CGRectZero)
  let nameLabel = UILabel(frame: CGRectZero)
  let buyButton = UIButton(frame: CGRectZero)
  let buyLink: NSURL?
  var containerOffset = CGPointZero

  init(product: Product) {
    buyLink = product.linkURL
    super.init(nibName: nil, bundle: nil)
    descriptionLabel.text = product.description
    descriptionLabel.numberOfLines = 2
    descriptionLabel.textColor = UIColor.whiteColor()
    descriptionLabel.font = UIFont.systemFontOfSize(8, weight: UIFontWeightHeavy)
    containerView.addSubview(descriptionLabel)
    nameLabel.text = product.name
    nameLabel.textColor = UIColor.whiteColor()
    nameLabel.font = UIFont.systemFontOfSize(7, weight: UIFontWeightUltraLight)
    containerView.addSubview(nameLabel)
    buyButton.setTitle("Get Now", forState: .Normal)
    buyButton.titleLabel?.font = UIFont.systemFontOfSize(8, weight: UIFontWeightBold)
    buyButton.backgroundColor = UIColor(red: 0.85, green: 0.12, blue: 0.09, alpha: 1)
    buyButton.layer.cornerRadius = 4
    buyButton.addTarget(self, action: "buyButtonDidGetTapped", forControlEvents: .TouchUpInside)
    containerView.addSubview(buyButton)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(containerView)
  }

  override func didMoveToParentViewController(parent: UIViewController?) {
    super.didMoveToParentViewController(parent)
    // Update container offset so as not to intersect with other overlays' containers
    containerOffset = CGPointZero
    guard let superview = view.superview else { return }
    for (index, overlayView) in superview.subviews.enumerate() {
      if (parentViewController?.childViewControllers[index] == self)
        || !CGRectIntersectsRect(overlayView.subviews[0].frame, view.frame) {
        return
      }
      containerOffset.x += overlayView.subviews[0].frame.size.width + 8
    }
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let availableSize = CGSize(width: BuyOverlayViewController.maxWidth - 16, height: CGFloat.infinity)
    var totalHeight = CGFloat(8);
    descriptionLabel.frame.size = descriptionLabel.sizeThatFits(availableSize)
    descriptionLabel.frame.origin = CGPoint(x: 8, y: totalHeight)
    totalHeight += descriptionLabel.frame.size.height
    nameLabel.frame.size = nameLabel.sizeThatFits(availableSize)
    nameLabel.frame.origin = CGPoint(x: 8, y: totalHeight)
    totalHeight += nameLabel.frame.size.height + 8
    buyButton.frame.size = buyButton.sizeThatFits(availableSize)
    buyButton.frame.size.width += 16
    buyButton.frame.origin.x = (descriptionLabel.frame.size.width - buyButton.frame.size.width) / 2
    buyButton.frame.origin.y = totalHeight
    totalHeight += buyButton.frame.size.height + 8
    containerView.frame.size = CGSize(width: descriptionLabel.frame.size.width + 16, height: totalHeight)
    containerView.frame.origin = containerOffset
  }

  func buyButtonDidGetTapped() {
    guard let buyLink = buyLink else { return }
    UIApplication.sharedApplication().openURL(buyLink)
  }
}
