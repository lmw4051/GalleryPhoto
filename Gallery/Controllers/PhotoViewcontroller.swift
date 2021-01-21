//
//  MainViewController.swift
//  Gallery
//
//  Created by David on 2021/1/20.
//  Copyright © 2021 David. All rights reserved.
//

import UIKit

class PhotoViewcontroller: UIViewController {
  // MARK: - Properties
  let photoVM = PhotoViewModel()
  
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
  
  // For Searching
  var searchController = UISearchController(searchResultsController: nil)
  
  // For Error Message
  private lazy var emptyView: EmptyView = {
    let view = EmptyView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    photoVM.delegate = self
    
    photoVM.getPhotoItems()
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
}

// MARK: - UICollectionViewDataSource Methods
extension PhotoViewcontroller: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {    
    return photoVM.photoItems.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
    cell.photo = photoVM.photoItems[indexPath.item]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PagingView.reuseIdentifier, for: indexPath)
    guard let pagingView = view as? PagingView else { return view }
    pagingView.isLoading = photoVM.isFetching
    return pagingView
  }
}

// MARK: - UICollectionViewDelegate Methods
extension PhotoViewcontroller: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 5 {
      photoVM.pageNumber += 1
      photoVM.getMoreItems()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let photoItem = photoVM.photoItems[indexPath.item]
    let vc = PhotoDetailViewController()
    vc.photoItem = photoItem
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - WaterfallLayoutDelegate Method
extension PhotoViewcontroller: WaterfallLayoutDelegate {
  func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let photo = photoVM.photoItems[indexPath.item]
    return .init(width: photo.width, height: photo.height)
  }
}

// MARK: - UISearchBarDelegate Method
extension PhotoViewcontroller: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    photoVM.clearPhotoItems()
    
    if let searchText = searchBar.text {
      hideEmptyView()
      
      if searchText == "" {
        photoVM.getPhotoItems()
      }
      
      photoVM.query = searchText
      photoVM.getPhotoItems(query: photoVM.query)
    }
  }
}

extension PhotoViewcontroller: PhotoViewModelDelegate {
  func photoItemsIsEmpty() {
    spinner.startAnimating()
  }
  
  func didNotGetAnyResult(state: EmptyViewState) {
    DispatchQueue.main.async {
      self.showEmptyView(with: .noResult)
    }
  }
  
  func updatePhotoItemData(newIndexPaths: [IndexPath]) {
    DispatchQueue.main.async {
      self.spinner.stopAnimating()
      self.hideEmptyView()

      let hasWindow = self.collectionView.window != nil
      let collectionViewItemCount = self.collectionView.numberOfItems(inSection: 0)

      if hasWindow && collectionViewItemCount < self.photoVM.photoItems.count {
        self.collectionView.insertItems(at: newIndexPaths)
        self.layout.invalidateLayout()
      } else {
        self.collectionView.reloadData()
      }
    }
  }
  
  func getErrorFromService(state: EmptyViewState) {
    DispatchQueue.main.async {
      self.showEmptyView(with: state)
    }
  }
  
  func clearPhotoItems() {
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
}
