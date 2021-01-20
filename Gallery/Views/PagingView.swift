//
//  PagingView.swift
//  Gallery
//
//  Created by David on 2021/1/20.
//  Copyright © 2021 David. All rights reserved.
//

import UIKit

class PagingView: UICollectionReusableView {
  
  // MARK: - Properties
  
  static var height: CGFloat = 44
  static var reuseIdentifier = "PagingView"
  
  private let spinner: UIActivityIndicatorView = {
    if #available(iOS 13.0, *) {
      let spinner = UIActivityIndicatorView(style: .medium)
      return spinner
    } else {
      let spinner = UIActivityIndicatorView(style: .gray)
      return spinner
    }
  }()
  
  var isLoading = false {
    didSet {
      if isLoading {
        spinner.startAnimating()
      } else {
        spinner.stopAnimating()
      }
    }
  }
  
  // MARK: - Lifetime
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSpinner()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setupSpinner()
  }
  
  // MARK: - Setup
  
  private func setupSpinner() {
    addSubview(spinner)
    spinner.centerInSuperview()
  }
}

