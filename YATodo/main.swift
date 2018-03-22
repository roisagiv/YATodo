//
//  main.swift
//  YATodo
//
//  Created by Roi Sagiv on 23/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Foundation
import UIKit

private func delegateClassName() -> String? {
  return NSClassFromString("XCTestCase") == nil ?
    NSStringFromClass(AppDelegate.self) :
    NSStringFromClass(TestAppDelegate.self)
}

private let unsafeArgv = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
  .bindMemory(
    to: UnsafeMutablePointer<Int8>.self,
    capacity: Int(CommandLine.argc)
  )

UIApplicationMain(CommandLine.argc, unsafeArgv, nil, delegateClassName())
