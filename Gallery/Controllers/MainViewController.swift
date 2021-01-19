//
//  MainViewController.swift
//  Gallery
//
//  Created by David on 2021/1/20.
//  Copyright © 2021 David. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    
    Service.shared.loadPhotos(perPage: 10, pageNumber: 15) { (items, error) in
      if let error = error {
        print("Failed to fetch:", error)
        return
      }
      
      print(items)
    }
  }
}
