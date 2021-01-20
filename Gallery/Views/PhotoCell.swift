//
//  PhotoCell.swift
//  Gallery
//
//  Created by David on 2021/1/20.
//  Copyright © 2021 David. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
  // MARK: - Properties
  static let reuseIdentifier = "PhotoCell"
  
  var photo: PhotoItem! {
    didSet {
      photoView.configure(with: photo)
    }
  }
  
  let photoView: PhotoView = {
    let photoView = PhotoView()
    return photoView
  }()
  
  // MARK: - View Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initSetup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initSetup()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    photoView.prepareForReuse()
  }
  
  // MARK: - Helper Methods
  func initSetup() {
    setupPhotoView()
  }
  
  func setupPhotoView() {
    contentView.addSubview(photoView)
    photoView.fillSuperview()
  }
}
