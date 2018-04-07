//
//  TodoNetworkService.swift
//  YATodo
//
//  Created by Roi Sagiv on 22/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Moya
import RxSwift

protocol TodoNetworkService {
  func all() -> Single<[TodoModel]>

  // swiftlint:disable:next identifier_name
  func get(id: Int) -> Single<TodoModel>

  func update(todo: TodoModel) -> Single<TodoModel>

  func create(title: String, completed: Bool) -> Single<TodoModel>

  // swiftlint:disable:next identifier_name
  func delete(id: Int) -> Single<Response>
}

struct MoyaTodoNetworkService: TodoNetworkService {
  private let provider: MoyaProvider<JsonPlaceHolderAPI>

  init(log: Bool) {
    var plugins: [PluginType] = []
    if log {
      plugins.append(NetworkLoggerPlugin(verbose: true, cURL: true))
    }

    provider = MoyaProvider<JsonPlaceHolderAPI>(plugins: plugins)
  }

  func all() -> Single<[TodoModel]> {
    return provider.rx
      .request(.all)
      .filterSuccessfulStatusAndRedirectCodes()
      .map([TodoModel].self)
  }

  // swiftlint:disable:next identifier_name
  func get(id: Int) -> Single<TodoModel> {
    return provider.rx
      .request(.get(id: id))
      .filterSuccessfulStatusAndRedirectCodes()
      .map(TodoModel.self)
  }

  func update(todo: TodoModel) -> Single<TodoModel> {
    return provider.rx
      .request(.update(id: todo.id, title: todo.title, completed: todo.completed))
      .filterSuccessfulStatusAndRedirectCodes()
      .map(TodoModel.self)
  }

  func create(title: String, completed: Bool) -> Single<TodoModel> {
    return provider.rx
      .request(.create(title: title, completed: completed))
      .filterSuccessfulStatusAndRedirectCodes()
      .map(TodoModel.self)
  }

  // swiftlint:disable:next identifier_name
  func delete(id: Int) -> Single<Response> {
    return provider.rx
      .request(.delete(id: id))
      .filterSuccessfulStatusAndRedirectCodes()
  }
}
