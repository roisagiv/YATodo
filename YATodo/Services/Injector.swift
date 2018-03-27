//
//  Injector.swift
//  YATodo
//
//  Created by Roi Sagiv on 23/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import GRDB
import Swinject
import UIKit

class Injector {

  class func todoListViewModel() -> TodoListViewModel {
    return container.resolve(TodoListViewModel.self)!
  }

  // swiftlint:disable:next identifier_name
  class func todoItemViewModel(id: Int?) -> TodoItemViewModel {
    return container.resolve(TodoItemViewModel.self, argument: id)!
  }

  class func router() -> Router {
    return container.resolve(Router.self)!
  }

  private static var container: Container!

  class func configure(application: UIApplication) {
    let log = false
    container = Container { container in
      container.register(TodoNetworkService.self) { _ in
        MoyaTodoNetworkService(log: log)
      }

      container.register(DatabaseWriter.self) { _ in
        let writer = DBFactory.inMemory(log: log)
        do {
          try DBMigrationService.migrate(database: writer)
        } catch {}
        return writer
      }

      container.register(TodoStorageService.self) { resolver in
        GRDBTodoStorageService(database: resolver.resolve(DatabaseWriter.self)!)
      }.inObjectScope(.container)

      container.register(TodoRepository.self) { resolver in
        TodoRepository(
          storage: resolver.resolve(TodoStorageService.self)!,
          network: resolver.resolve(TodoNetworkService.self)!
        )
      }

      container.register(TodoListViewModel.self) { resolver in
        DefaultTodoListViewModel(repository: resolver.resolve(TodoRepository.self)!)
      }

      // swiftlint:disable:next identifier_name
      container.register(TodoItemViewModel.self) { resolver, id in
        DefaultTodoItemViewModel(repository: resolver.resolve(TodoRepository.self)!, id: id)
      }

      container.register(Router.self) { _ in
        DefaultRouter()
      }
    }
  }
}
