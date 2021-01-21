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
  
  private let imageView = UIImageView(cornerRadius: 0)
  
  private let pagingView: PagingView = {
    let view = PagingView()
    return view
  }()
  
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
    guard let image = imageView.image else { return }
    
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(photoSaved), nil)
  }
  
  @objc func photoSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    print("photoSaved")
    showAlertMsg(msg: "Photo Saved")
  }
}
