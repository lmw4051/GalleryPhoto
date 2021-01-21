//
//  NSError+Extensions.swift
//  Gallery
//
//  Created by David on 2021/1/21.
//  Copyright © 2021 David. All rights reserved.
//

import Foundation

extension NSError {
  func isNoInternetConnectionError() -> Bool {
    let noInternetConnectionErrorCodes = [
      NSURLErrorNetworkConnectionLost,
      NSURLErrorNotConnectedToInternet,
      NSURLErrorInternationalRoamingOff,
      NSURLErrorCallIsActive,
      NSURLErrorDataNotAllowed
    ]
    
    if domain == NSURLErrorDomain && noInternetConnectionErrorCodes.contains(code) {
      return true
    }
    
    return false
  }
}
