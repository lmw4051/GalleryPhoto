//
//  GalleryItem.swift
//  Gallery
//
//  Created by David on 2021/1/20.
//  Copyright © 2021 David. All rights reserved.
//

import Foundation

struct PhotoItem: Codable {
  let urls: URLKind
  let width: Int
  let height: Int
}

struct URLKind: Codable {
  let raw: String
  let full: String
  let regular: String
  let small: String
  let thumb: String
}

struct SearchResponse: Decodable {
  let total: Int?
  let totalPages: Int?
  let results: [PhotoItem]?
}