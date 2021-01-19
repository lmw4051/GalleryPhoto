//
//  Service.swift
//  Gallery
//
//  Created by David on 2021/1/20.
//  Copyright © 2021 David. All rights reserved.
//

import Foundation

class Service {
  static let shared = Service()
  
  func loadPhotos(perPage: Int = 15,
                  pageNumber: Int = 0,
                  completion: @escaping ([GalleryItem]?, Error?) -> Void) {
    var components = URLComponents()
    components.scheme = AppConstants.scheme
    components.host = AppConstants.host
    components.path = AppConstants.photosPath
    components.queryItems = [
      URLQueryItem(name: "client_id", value: UnSplashKey),
      URLQueryItem(name: "page", value: "\(pageNumber)"),
      URLQueryItem(name: "per_page", value: "\(perPage)")
    ]
    
    guard let url = components.url else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion(nil, error)
        return
      }
      
      guard let data = data else { return }
      
      do {
        let objects = try JSONDecoder().decode([GalleryItem].self, from: data)
        completion(objects, nil)
      } catch let jsonError {
        completion(nil, jsonError)
      }
    }.resume()
  }
}
