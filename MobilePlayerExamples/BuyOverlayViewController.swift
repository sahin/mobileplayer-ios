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
  let containerView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
  let descriptionLabel = UILabel(frame: CGRect.zero)
  let nameLabel = UILabel(frame: CGRect.zero)
  let buyButton = UIButton(frame: CGRect.zero)
  let buyLink: URL?
  var containerOffset = CGPoint.zero

  init(product: Product) {
    buyLink = product.linkURL
    super.init(nibName: nil, bundle: nil)
    descriptionLabel.text = product.description
    descriptionLabel.numberOfLines = 2
    descriptionLabel.textColor = UIColor.white
    descriptionLabel.font = UIFont.systemFont(ofSize: 8, weight: .heavy)
    containerView.addSubview(descriptionLabel)
    nameLabel.text = product.name
    nameLabel.textColor = UIColor.white
    nameLabel.font = UIFont.systemFont(ofSize: 7, weight: .ultraLight)
    containerView.addSubview(nameLabel)
    buyButton.setTitle("Get Now", for: .normal)
    buyButton.titleLabel?.font = UIFont.systemFont(ofSize: 8, weight: .bold)
    buyButton.backgroundColor = UIColor(red: 0.85, green: 0.12, blue: 0.09, alpha: 1)
    buyButton.layer.cornerRadius = 4
    buyButton.addTarget(self, action: #selector(buyButtonDidGetTapped), for: .touchUpInside)
    containerView.addSubview(buyButton)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(containerView)
  }

  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)
    // Update container offset so as not to intersect with other overlays' containers
    containerOffset = CGPoint.zero
    guard let superview = view.superview else { return }
    for (index, overlayView) in superview.subviews.enumerated() {
      if (parent?.children[index] == self)
        || !overlayView.subviews[0].frame.intersects(view.frame) {
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

  @objc func buyButtonDidGetTapped() {
    guard let buyLink = buyLink else { return }
    UIApplication.shared.openURL(buyLink)
  }
}
