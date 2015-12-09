//
//  ProductStore.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 23/11/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import Foundation

public class ProductStore {
  private static let products = [
    "1": Product(
      id: "1",
      name: "Dark Side Galactic Clubs Life Time Membership",
      description: "Limited time offer! Pay once for a life time membership in our exclusive club!",
      price: 49.99,
      link: "http://google.com"),
    "2": Product(
      id: "2",
      name: "Space Ships by Star Forge LLC",
      description: "Have your own Sith armada with 50% off!",
      price: 199.99,
      link: "http://google.com"),
    "3": Product(
      id: "3",
      name: "Light Knife by Cook Republic",
      description: "Cut and cook your meat at the same time!",
      price: 20.49,
      link: "http://google.com")]
  private static let placements = [
    "1": [
      ProductPlacement(productID: "2", startTime: 4.49, duration: 7.45),
      ProductPlacement(productID: "3", startTime: 3, duration: 6)]]

  public static func getProduct(productID: String, success: Product? -> Void, failure: (NSError -> Void)? = nil) {
    success(products[productID])
  }

  public static func getProductPlacementsForVideo(videoID: String, success: [ProductPlacement]? -> Void, failure: (NSError -> Void)? = nil) {
    success(placements[videoID])
  }
}

public struct Product {
  public let id: String
  public let name: String
  public let description: String
  public let price: Double
  public let link: String

  public var linkURL: NSURL? {
    return NSURL(string: link)
  }
}

public struct ProductPlacement {
  public let productID: String
  public let startTime: NSTimeInterval?
  public let duration: NSTimeInterval?
}
