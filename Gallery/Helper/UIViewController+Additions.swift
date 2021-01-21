//
//  UIViewController+Additions.swift
//  Gallery
//
//  Created by David on 2021/1/21.
//  Copyright © 2021 David. All rights reserved.
//

import UIKit

extension UIViewController {
  func showAlertMsg(msg: String) {
    let alertController = UIAlertController(title: "Message", message: msg, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
}
