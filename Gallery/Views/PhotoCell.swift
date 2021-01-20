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
  var gallery: GalleryItem! {
    didSet {
      print(gallery.urls)
      imageView.sd_setImage(with: URL(string: gallery.urls.regular))
    }
  }
  
  static let reuseIdentifier = "PhotoCell"
  
  let imageView = UIImageView(cornerRadius: 0)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    imageView.fillSuperview()
    addSubview(imageView)
    imageView.fillSuperview()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
