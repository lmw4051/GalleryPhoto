//
//  ImageSaver.swift
//  Gallery
//
//  Created by David on 2021/1/21.
//  Copyright © 2021 David. All rights reserved.
//

import UIKit

class ImageSaver: NSObject {
  var successHanlder: (() -> Void)?
  var errorHandler: ((Error) -> Void)?
  
  func writeToPhotoAlbum(image: UIImage) {
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
  }
  
  @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
      errorHandler?(error)
    } else {
      successHanlder?()
    }
  }
}
