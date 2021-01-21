//
//  AppDelegate.swift
//  Gallery
//
//  Created by David on 2021/1/19.
//  Copyright © 2021 David. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow()
    window?.rootViewController = UINavigationController(rootViewController: PhotoViewcontroller())
    window?.makeKeyAndVisible()
    return true
  }
}
