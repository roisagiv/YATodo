//
//  AppDelegate.swift
//  YATodo
//
//  Created by Roi Sagiv on 21/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import GRDB
import MaterialComponents
import Swinject
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    MDCIcons.ic_arrow_backUseNewStyle(true)
    Injector.configure(application: application)

    let window = UIWindow(frame: UIScreen.main.bounds)
    let router = Injector.router()
    router.navigate(to: .list, from: window)
    window.makeKeyAndVisible()

    self.window = window

    return true
  }
}
