//
//  JSONs.swift
//  YATodoTests
//
//  Created by Roi Sagiv on 26/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Foundation

class JSONs {
  class func codableFromFile<T>(_ name: String, type: T.Type) -> T where T: Decodable {
    let bundle = Bundle(for: self)
    let path = bundle.path(forResource: name, ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path))
    let decoder = JSONDecoder()
    return try! decoder.decode(T.self, from: data)
  }
}
