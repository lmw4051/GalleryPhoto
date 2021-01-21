//
//  PhotoViewModel.swift
//  Gallery
//
//  Created by David on 2021/1/22.
//  Copyright © 2021 David. All rights reserved.
//

import UIKit

protocol PhotoViewModelDelegate: AnyObject {
  func photoItemsIsEmpty()
  func didNotGetAnyResult(state: EmptyViewState)
  func updatePhotoItemData(newIndexPaths: [IndexPath])
  func getErrorFromService(state: EmptyViewState)
  func clearPhotoItems()
}

class PhotoViewModel {
  let clientService: GalleryClientService
  weak var delegate: PhotoViewModelDelegate?
  
  // For DataSource
  var photoItems = [PhotoItem]()
  
  // For Pagination
  var pageNumber = 1
  private(set) var isFetching = false
  
  var query = ""
  
  init(clientService: GalleryClientService = GalleryClient()) {
    self.clientService = clientService
  }
  
  // MARK: - API Section
  func getMoreItems() {
    getPhotoItems(query: query)
  }
  
  func getPhotoItems(query: String = "") {
    isFetching = true
    
    if photoItems.count == 0 {
      delegate?.photoItemsIsEmpty()
    }
    
    clientService.loadPhotos(query: query, perPage: 10, pageNumber: pageNumber, completion: { items in
      guard let items = items, items.count > 0 else {
        self.isFetching = false
        self.delegate?.didNotGetAnyResult(state: .noResult)
        return
      }
      
      for item in items {
        self.photoItems.append(item)
      }
      
      self.isFetching = false
      
      let newPhotosCount = items.count
      let startIndex = self.photoItems.count - newPhotosCount
      let endIndex = startIndex + newPhotosCount
      var newIndexPaths = [IndexPath]()
      
      for index in startIndex..<endIndex {
        newIndexPaths.append(IndexPath(item: index, section: 0))
      }
      
      self.delegate?.updatePhotoItemData(newIndexPaths: newIndexPaths)
    }) { error in
      self.isFetching = false
      let state: EmptyViewState = (error as NSError).isNoInternetConnectionError() ? .noInternetConnection : .serverError
      
      self.delegate?.getErrorFromService(state: state)
    }
  }
  
  func clearPhotoItems() {
    pageNumber = 1
    photoItems = [PhotoItem]()
    
    delegate?.clearPhotoItems()
  }
}
