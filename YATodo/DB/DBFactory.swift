//
//  DBFactory.swift
//  YATodo
//
//  Created by Roi Sagiv on 24/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import GRDB

struct DBFactory {

  static func inMemory(log: Bool) -> DatabaseQueue {
    var configuration = Configuration()
    if log {
      configuration.trace = { print("SQL: \($0)") }
    }
    return DatabaseQueue(configuration: configuration)
  }
}
