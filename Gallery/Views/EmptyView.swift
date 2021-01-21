//
//  EmptyView.swift
//  Gallery
//
//  Created by David on 2021/1/21.
//  Copyright © 2021 David. All rights reserved.
//

import UIKit

enum EmptyViewState {
  case noResult
  case noInternetConnection
  case serverError
  
  var title: String {
    switch self {
    case .noResult:
      return "No results"
    case .noInternetConnection:
      return "No Internet Connection"
    case .serverError:
      return "Server error"
    }
  }
  
  var description: String {
    switch self {
    case .noResult:
      return "Please update your search and try again."
    case .noInternetConnection:
      return "You must connect to a Wi-Fi or cellular data network to access Unsplash."
    case .serverError:
      return "Oops! Something's wrong. Please try again."
    }
  }
}

class EmptyView: UIView {
  // MARK: - Properties
  private lazy var containerView: UIView = {
    let view = UIView()
    return view
  }()
  
  private lazy var titleLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 24.0), textColor: .black, textAlignment: .center, numberOfLines: 0)  
  private lazy var descriptionLabel = UILabel(text: "", font: .systemFont(ofSize: 16.0), textColor: .gray, textAlignment: .center, numberOfLines: 0)
  
  var state: EmptyViewState? {
    didSet {
      setupState()
    }
  }
  
  // MARK: - Lifetime
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    
    setupContainerView()
    setupTitleLabel()
    setupDescriptionLabel()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  private func setupContainerView() {
    addSubview(containerView)
    containerView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
    containerView.centerYInSuperview()
  }
  
  private func setupTitleLabel() {
    containerView.addSubview(titleLabel)
    titleLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
  }
  
  private func setupDescriptionLabel() {
    containerView.addSubview(descriptionLabel)
    descriptionLabel.anchor(top: titleLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 8, left: 20, bottom: 0, right: 20))
  }
  
  private func setupState() {
    titleLabel.text = state?.title
    descriptionLabel.text = state?.description
  }
}
