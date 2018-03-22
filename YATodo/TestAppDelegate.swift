//
//  TestAppDelegate.swift
//  YATodo
//
//  Created by Roi Sagiv on 23/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Foundation
import UIKit

class TestAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_: UIApplication,
                   didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)

    window?.rootViewController = UIViewController()
    window?.makeKeyAndVisible()

    return true
  }

  class func displayAsRoot(viewController: UIViewController) {
    let appDelegate = UIApplication.shared.delegate as? TestAppDelegate
    let window = appDelegate?.window
    window?.rootViewController = viewController
    window?.makeKeyAndVisible()
  }
}
