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
      pagingView.isLoading = true
      imageView.sd_setImage(with: URL(string: photoItem.urls.regular)) { (_, _, _, _) in
        self.pagingView.isLoading = false
      }
    }
  }
  
  // For displaying image
  private let imageView = UIImageView(cornerRadius: 0)
  
  // For HUD
  private let pagingView: PagingView = {
    let view = PagingView()
    return view
  }()
  
  // For Image Saving
  private lazy var imageSaver = ImageSaver()
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupImageView()
    setupPagingView()
    setupNavBarBtns()
  }
  
  fileprivate func setupImageView() {
    view.addSubview(imageView)
    imageView.fillSuperview()
  }
  
  fileprivate func setupPagingView() {
    view.addSubview(pagingView)
    pagingView.centerInSuperview()
    pagingView.constrainWidth(constant: 44)
    pagingView.constrainHeight(constant: 44)

  }
  fileprivate func setupNavBarBtns() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadBtnPressed))
  }
      
  @objc func downloadBtnPressed() {
    print("downloadBtnPressed")
    imageSaver.successHanlder = { [weak self] in
      guard let self = self else { return }
      self.showAlertMsg(msg: "Photo Saved Successfully")
    }
    
    imageSaver.errorHandler = { [weak self] in
      guard let self = self else { return }
      self.showAlertMsg(msg: "Opps: \($0.localizedDescription)")
    }
    
    guard let image = imageView.image else { return }
    imageSaver.writeToPhotoAlbum(image: image)
  }
}
