//
//  PhotoView.swift
//  Gallery
//
//  Created by David on 2021/1/20.
//  Copyright © 2021 David. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoView: UIView {
  // MARK: - Properties
  let imageView = UIImageView(cornerRadius: 0)

  // MARK: - View Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(imageView)
    imageView.fillSuperview()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  func prepareForReuse() {
    imageView.backgroundColor = .clear
    imageView.image = nil
  }
  
  func configure(with photo: PhotoItem) {
    imageView.sd_setImage(with: URL(string: photo.urls.thumb))
  }
}
