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
  // UICollectionView
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
  
  // For DataSource
  var photoItems = [PhotoItem]()
  
  private let spinner: UIActivityIndicatorView = {
    if #available(iOS 13.0, *) {
      let spinner = UIActivityIndicatorView(style: .medium)
      spinner.hidesWhenStopped = true
      return spinner
    } else {
      let spinner = UIActivityIndicatorView(style: .gray)      
      spinner.hidesWhenStopped = true
      return spinner
    }
  }()
  
  // For Pagination
  var pageNumber = 1
  private(set) var isFetching = false
  
  // For Searching
  var searchController = UISearchController(searchResultsController: nil)
  var query = ""
  
  // For Error Message
  private lazy var emptyView: EmptyView = {
    let view = EmptyView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    getPhotoItems()
    setupCollectionView()
    setupSpinner()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavBar()
  }
  
  // MARK: - Helper Methods
  private func setupNavBar() {
    navigationItem.title = "Gallery"
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = searchController
    
    setupSearchController()
  }
  
  private func setupSearchController() {
    searchController.searchBar.delegate = self
    searchController.searchBar.placeholder = "Search Images"
    searchController.searchBar.returnKeyType = UIReturnKeyType.search
    searchController.obscuresBackgroundDuringPresentation = false
  }
  
  private func setupCollectionView() {
    view.addSubview(collectionView)
    collectionView.fillSuperview()
  }
  
  private func setupSpinner() {
    view.addSubview(spinner)
    spinner.centerInSuperview()
  }
  
  private func showEmptyView(with state: EmptyViewState) {
    emptyView.state = state
    guard emptyView.superview == nil else { return }
    spinner.stopAnimating()
    view.addSubview(emptyView)
    
    NSLayoutConstraint.activate([
      emptyView.topAnchor.constraint(equalTo: view.topAnchor),
      emptyView.leftAnchor.constraint(equalTo: view.leftAnchor),
      emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      emptyView.rightAnchor.constraint(equalTo: view.rightAnchor)
    ])
  }
  
  private func hideEmptyView() {
    emptyView.removeFromSuperview()
  }
  
  // MARK: - API Section
  private func getMoreItems() {
    getPhotoItems(query: query)
  }
  
  private func getPhotoItems(query: String = "") {
    isFetching = true
    
    if photoItems.count == 0 {
      spinner.startAnimating()
    }
    
    let completionHandler: (([PhotoItem]?, Error?) -> Void) = { [weak self] (items, error) in
      guard let self = self else { return }
      
      if let error = error {
        print("Failed to fetch:", error)
        
        let state: EmptyViewState = (error as NSError).isNoInternetConnectionError() ? .noInternetConnection : .serverError
        
        DispatchQueue.main.async {
          self.showEmptyView(with: state)
        }
        
        self.isFetching = false
        return
      }
      
      guard let items = items, items.count > 0 else {
        self.isFetching = false
        
        DispatchQueue.main.async {
          self.showEmptyView(with: .noResult)
        }
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
      
      DispatchQueue.main.async {
        self.spinner.stopAnimating()
        self.hideEmptyView()
                
        let hasWindow = self.collectionView.window != nil
        let collectionViewItemCount = self.collectionView.numberOfItems(inSection: 0)
        
        if hasWindow && collectionViewItemCount < self.photoItems.count {
          self.collectionView.insertItems(at: newIndexPaths)
          self.layout.invalidateLayout()
        } else {
          self.collectionView.reloadData()
        }
      }
    }
    
    if query.isEmpty {
      Service.shared.loadPhotos(perPage: 10, pageNumber: pageNumber, completion: completionHandler)
    } else {
      Service.shared.loadPhotos(query: query, perPage: 10, pageNumber: pageNumber, completion: completionHandler)
    }
  }
  
  private func clearPhotoItems() {
    pageNumber = 1
    photoItems = [PhotoItem]()
    
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
}

// MARK: - UICollectionViewDataSource Methods
extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {    
    return photoItems.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
    cell.photo = photoItems[indexPath.item]
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
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let photoItem = photoItems[indexPath.item]
    let vc = PhotoDetailViewController()
    vc.photoItem = photoItem
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - WaterfallLayoutDelegate Method
extension MainViewController: WaterfallLayoutDelegate {
  func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let photo = photoItems[indexPath.item]
    return .init(width: photo.width, height: photo.height)
  }
}

// MARK: - UISearchBarDelegate Method
extension MainViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    clearPhotoItems()
    
    if let searchText = searchBar.text {
      hideEmptyView()
      
      if searchText == "" {
        getPhotoItems()
      }
      
      query = searchText
      getPhotoItems(query: query)
    }
  }
}
