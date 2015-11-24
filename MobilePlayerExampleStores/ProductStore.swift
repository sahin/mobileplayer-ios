//
//  ProductStore.swift
//  MobilePlayer
//
//  Created by Baris Sencan on 23/11/2015.
//  Copyright © 2015 MovieLaLa. All rights reserved.
//

import Foundation

public class ProductStore {
  private let products = [
    "1": Product(id: "1", name: "", description: "", price: 9.99, link: ""),
    "2": Product(id: "2", name: "", description: "", price: 19.99, link: ""),
    "3": Product(id: "3", name: "", description: "", price: 40.49, link: "")]
  private let placements = [
    "1": [
      ProductPlacement(productID: "1", startTime: 4.49, endTime: 7.45),
      ProductPlacement(productID: "2", startTime: 3, endTime: 10)],
    "2": [
      ProductPlacement(productID: "3", startTime: 6, endTime: 9)]]

  public func getProduct(productID: String, success: (Product? -> Void), failure: ((NSError) -> Void)?) {
    success(products[productID])
  }

  public func getProductPlacementsForVideo(videoID: String, success: ([ProductPlacement]? -> Void), failure: ((NSError) -> Void)?) {
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
  public let startTime: NSTimeInterval
  public let endTime: NSTimeInterval
}