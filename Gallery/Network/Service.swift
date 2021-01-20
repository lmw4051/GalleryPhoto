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
                  completion: @escaping ([PhotoItem]?, Error?) -> Void) {
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
        let photoItems = try JSONDecoder().decode([PhotoItem].self, from: data)
        completion(photoItems, nil)
      } catch let jsonError {
        completion(nil, jsonError)
      }
    }.resume()
  }
  
  func loadPhotos(query: String,
                  perPage: Int = 15,
                  pageNumber: Int = 0,
                  completion: @escaping ([PhotoItem]?, Error?) -> Void) {
    var components = URLComponents()
      components.scheme = AppConstants.scheme
      components.host = AppConstants.host
      components.path = AppConstants.photosSearchPath
      components.queryItems = [
        URLQueryItem(name: "client_id", value: UnSplashKey),
        URLQueryItem(name: "page", value: "\(pageNumber)"),
        URLQueryItem(name: "per_page", value: "\(perPage)"),
        URLQueryItem(name: "query", value: query)
      ]
      
      guard let url = components.url else { return }
      
      URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
          completion(nil, error)
          return
        }
        
        guard let data = data else { return }
        
        var photoItems = [PhotoItem]()
        
        do {
          let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
          print(searchResponse)
          
          for photoItem in searchResponse.results! {
            photoItems.append(photoItem)
          }
          completion(photoItems, nil)
        } catch let jsonError {
          completion(nil, jsonError)
        }
      }.resume()
    }
}
