//
//  PhotoDetailViewController.swift
//  Gallery
//
//  Created by David on 2021/1/20.
//  Copyright © 2021 David. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
  // MARK: - Properties
  var photoItem: PhotoItem! {
    didSet {
      print(photoItem.urls)
//      imageView.sd_setImage(with: URL(string: photoItem.urls.full))
      pagingView.isLoading = true
      imageView.sd_setImage(with: URL(string: photoItem.urls.regular)) { (_, _, _, _) in
        self.pagingView.isLoading = false
      }
    }
  }
  
  private let imageView = UIImageView(cornerRadius: 0)
  
  private let pagingView: PagingView = {
    let view = PagingView()
    return view
  }()
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    view.addSubview(imageView)
    imageView.fillSuperview()
    
    view.addSubview(pagingView)
    pagingView.centerInSuperview()
    pagingView.constrainWidth(constant: 44)
    pagingView.constrainHeight(constant: 44)
  }
}
