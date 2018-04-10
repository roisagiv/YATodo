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
  case get(id: Int)
  case create(title: String, completed: Bool)
  case update(id: Int, title: String, completed: Bool)
  case delete(id: Int)
}

extension JsonPlaceHolderAPI: TargetType {
  var baseURL: URL {
    return URL(string: "https://jsonplaceholder.typicode.com")!
  }

  var headers: [String: String]? {
    return [
      "Content-type": "application/json; charset=UTF-8",
      "Accept": "application/json"
    ]
  }

  var method: Method {
    switch self {
    case .all, .get:
      return .get

    case .create:
      return .post

    case .update:
      return .put

    case .delete:
      return .delete
    }
  }

  var path: String {
    switch self {
    case .all, .create:
      return "/todos"
    case .get(let id), .delete(let id), .update(let id, _, _):
      return "/todos/\(id)"
    }
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    switch self {
    case .all, .get, .delete:
      return Task.requestPlain

    case .update(let id, let title, let completed):
      return Task.requestJSONEncodable(TodoModel(id: id, title: title, completed: completed))

    case .create(let title, let completed):
      return Task.requestParameters(
        parameters: [
          TodoModel.TodoKeys.title.stringValue: title,
          TodoModel.TodoKeys.completed.stringValue: completed
        ],
        encoding: JSONEncoding.default
      )
    }
  }

}
