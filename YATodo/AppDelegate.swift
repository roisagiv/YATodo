//
//  AppDelegate.swift
//  YATodo
//
//  Created by Roi Sagiv on 21/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import GRDB
import Swinject
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var container: Container!

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Injector.configure(application: application)

    let window = UIWindow(frame: UIScreen.main.bounds)
    let vc = TodoListViewController.new(viewModel: Injector.todoListViewModel())
    let nc = UINavigationController(rootViewController: vc)
    window.rootViewController = nc
    window.makeKeyAndVisible()

    self.window = window

    return true
  }
}
