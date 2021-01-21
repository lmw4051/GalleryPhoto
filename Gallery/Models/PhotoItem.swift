//
//  GalleryItem.swift
//  Gallery
//
//  Created by David on 2021/1/20.
//  Copyright © 2021 David. All rights reserved.
//

import UIKit

struct PhotoItem: Decodable {
  let urls: URLKind
  let width: Int
  let height: Int
  let user: User
  let color: String    
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

struct User: Codable {
  let userName: String
  let name: String?
  let firstName: String?
  let lastName: String?
  
  enum CodingKeys: String, CodingKey {
    case userName = "username", name, firstName = "first_name", lastName = "last_name"
  }
}

extension User {
  var displayName: String {
    if let name = name {
      return name
    }
    
    if let firstName = firstName {
      if let lastName = lastName {
        return "\(firstName) \(lastName)"
      }
      return firstName
    }
    return userName
  }
}
