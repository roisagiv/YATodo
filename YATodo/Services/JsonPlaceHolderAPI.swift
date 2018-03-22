//
//  JsonPlaceHolderAPI.swift
//  YATodo
//
//  Created by Roi Sagiv on 22/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Moya

enum JsonPlaceHolderAPI {
  case all
}

extension JsonPlaceHolderAPI: TargetType {
  var baseURL: URL {
    return URL(string: "https://jsonplaceholder.typicode.com")!
  }

  var headers: [String: String]? {
    return ["Content-type": "application/json; charset=UTF-8"]
  }

  var method: Method {
    switch self {
    case .all:
      return .get
    }
  }

  var path: String {
    switch self {
    case .all:
      return "/todos"
    }
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    switch self {
    case .all:
      return Task.requestPlain
    }
  }

}
