//
//  Service.swift
//  Gallery
//
//  Created by David on 2021/1/20.
//  Copyright © 2021 David. All rights reserved.
//

import Foundation

typealias completionWithPhotoItems = ([PhotoItem]?) -> Void
typealias completionWithError = (Error) -> Void

protocol GalleryClientService {
  func loadPhotos(query: String,
  perPage: Int,
  pageNumber: Int,
  completion: @escaping completionWithPhotoItems,
  fail: @escaping completionWithError)
}

class GalleryClient: GalleryClientService {
  static let shared = GalleryClient()
  
  func loadPhotos(query: String,
                  perPage: Int,
                  pageNumber: Int,
                  completion: @escaping completionWithPhotoItems,
                  fail: @escaping completionWithError) {
    var components = URLComponents()
    components.scheme = AppConstants.scheme
    components.host = AppConstants.host
    
    if query == "" {
      components.path = AppConstants.photosPath
      components.queryItems = [
        URLQueryItem(name: "client_id", value: UnSplashKey),
        URLQueryItem(name: "page", value: "\(pageNumber)"),
        URLQueryItem(name: "per_page", value: "\(perPage)")
      ]
    } else {
      components.path = AppConstants.photosSearchPath
      components.queryItems = [
        URLQueryItem(name: "client_id", value: UnSplashKey),
        URLQueryItem(name: "page", value: "\(pageNumber)"),
        URLQueryItem(name: "per_page", value: "\(perPage)"),
        URLQueryItem(name: "query", value: query)
      ]
    }
          
    guard let url = components.url else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        fail(error)
        return
      }
      
      guard let data = data else { return }
      
      var photoItems = [PhotoItem]()
      
      if query == "" {
        do {
          let photoItems = try JSONDecoder().decode([PhotoItem].self, from: data)
          completion(photoItems)
        } catch let jsonError {
          fail(jsonError)
        }
      } else {
        do {
          let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
          print(searchResponse)
          
          for photoItem in searchResponse.results! {
            photoItems.append(photoItem)
          }
          completion(photoItems)
        } catch let jsonError {
          fail(jsonError)
        }
      }
    }.resume()
  }
}
