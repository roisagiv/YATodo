//
//  AppDelegate.swift
//  YATodo
//
//  Created by Roi Sagiv on 21/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    let vc = TodoListViewController.new()
    let nc = UINavigationController(rootViewController: vc)
    window.rootViewController = nc
    window.makeKeyAndVisible()
    
    self.window = window
    
    return true
  }
}

