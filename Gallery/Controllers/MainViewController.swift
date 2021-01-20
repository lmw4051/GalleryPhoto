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
  var galleryItems = [GalleryPhoto]()
  
  private lazy var layout = WaterfallLayout(with: self)
  
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
    collectionView.layoutMargins = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    return collectionView
  }()
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    
    getItems()
    setupCollectionView()
  }
  
  fileprivate func getItems() {
    Service.shared.loadPhotos(perPage: 10, pageNumber: 15) { (items, error) in
      if let error = error {
        print("Failed to fetch:", error)
        return
      }
      
      guard let items = items else { return }
      
      for item in items {
        self.galleryItems.append(item)
      }
      
      print(self.galleryItems)
      
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  
  fileprivate func setupCollectionView() {
    view.addSubview(collectionView)
    collectionView.fillSuperview()
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
}

// MARK: - WaterfallLayoutDelegate
extension MainViewController: WaterfallLayoutDelegate {
  func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let photo = galleryItems[indexPath.item]
    return .init(width: photo.width, height: photo.height)
  }
}
