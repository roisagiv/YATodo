//
//  Sync.swift
//  YATodoTests
//
//  Created by Roi Sagiv on 26/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Foundation

class Sync {
  class func tick() {
    RunLoop.main.run(until: Date().addingTimeInterval(0.2))
  }
}
