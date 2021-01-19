//
//  GalleryItem.swift
//  Gallery
//
//  Created by David on 2021/1/20.
//  Copyright © 2021 David. All rights reserved.
//

import Foundation

struct GalleryItem: Codable {
  let urls: Urls
}

struct Urls: Codable {
  let raw: String
  let full: String
  let regular: String
  let small: String
  let thumb: String
}
