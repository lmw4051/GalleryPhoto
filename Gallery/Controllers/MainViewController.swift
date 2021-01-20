//
//  MainViewController.swift
//  Gallery
//
//  Created by David on 2021/1/20.
//  Copyright © 2021 David. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  // MARK: - Properties
  var galleryItems = [PhotoItem]()
  
  // MARK: - UICollectionView
  private lazy var layout = WaterfallLayout(with: self)
  
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
    collectionView.register(PagingView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PagingView.reuseIdentifier)
    collectionView.layoutMargins = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  // MARK: - For Pagination
  var pageNumber = 1
  private(set) var isFetching = false
  
  // MARK: - For Searching
  var searchController = UISearchController(searchResultsController: nil)
  var query = ""
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    getPhotoItems()
    setupCollectionView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavBar()
  }
  
  // MARK: - Helper Methods
  fileprivate func setupNavBar() {
    navigationItem.title = "Gallery"    
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = searchController
    
    setupSearchController()
  }
  
  fileprivate func setupSearchController() {
    searchController.searchBar.delegate = self
    searchController.searchBar.placeholder = "Search Images"
    searchController.obscuresBackgroundDuringPresentation = false
  }
    
  fileprivate func setupCollectionView() {
    view.addSubview(collectionView)
    collectionView.fillSuperview()
  }
  
  fileprivate func getMoreItems() {
    getPhotoItems(query: query)
  }
  
  fileprivate func getPhotoItems(query: String = "") {
    isFetching = true
    
    let completionHandler: (([PhotoItem]?, Error?) -> Void) = { (items, error) in
      if let error = error {
        self.isFetching = false
        print("Failed to fetch:", error)
        return
      }
      
      guard let items = items else {
        self.isFetching = false
        return
      }
      
      for item in items {
        self.galleryItems.append(item)
      }
      
      self.isFetching = false
      
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
    
    if query.isEmpty {
      Service.shared.loadPhotos(perPage: 10, pageNumber: pageNumber, completion: completionHandler)
    } else {
      Service.shared.loadPhotos(query: query, perPage: 10, pageNumber: pageNumber, completion: completionHandler)
    }
  }
  
  fileprivate func clearPhotoItems() {
    pageNumber = 1
    galleryItems = [PhotoItem]()
    
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
}

// MARK: - UICollectionViewDataSource Methods
extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {    
    return galleryItems.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
    cell.photo = galleryItems[indexPath.item]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PagingView.reuseIdentifier, for: indexPath)
    guard let pagingView = view as? PagingView else { return view }
    pagingView.isLoading = isFetching
    return pagingView
  }
}

// MARK: - UICollectionViewDelegate Methods
extension MainViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 5 {
      pageNumber += 1
      getMoreItems()
    }
  }
}

// MARK: - WaterfallLayoutDelegate
extension MainViewController: WaterfallLayoutDelegate {
  func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let photo = galleryItems[indexPath.item]
    return .init(width: photo.width, height: photo.height)
  }
}

extension MainViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    clearPhotoItems()
    
    if let searchText = searchBar.text {
      if searchText == "" {
        getPhotoItems()
      }
      
      query = searchText
      getPhotoItems(query: query)
    }
  }
}
