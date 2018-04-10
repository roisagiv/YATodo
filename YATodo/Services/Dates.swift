//
//  Dates.swift
//  YATodo
//
//  Created by Roi Sagiv on 11/04/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Foundation

protocol Dates {
  func today() -> Date
}

struct DefaultDates: Dates {
  func today() -> Date {
    return Date()
  }
}
