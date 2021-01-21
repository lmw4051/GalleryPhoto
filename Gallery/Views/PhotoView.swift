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
  private lazy var imageView = UIImageView(cornerRadius: 0)
  private lazy var nameLabel = UILabel(text: "", font: .systemFont(ofSize: 13, weight: .medium), textColor: .white)
  
  // MARK: - View Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupImageView()
    setupNameLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  private func setupImageView() {
    addSubview(imageView)
    imageView.fillSuperview()
  }
  
  private func setupNameLabel() {
    addSubview(nameLabel)
    nameLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 8, right: 16))
    nameLabel.constrainHeight(constant: 16)
  }
  
  func prepareForReuse() {
    imageView.backgroundColor = .clear
    imageView.image = nil
    nameLabel.text = nil
  }
  
  func configure(with photo: PhotoItem, showUserName: Bool = true) {
    imageView.sd_setImage(with: URL(string: photo.urls.thumb))
    nameLabel.text = photo.user.displayName
  }
}
