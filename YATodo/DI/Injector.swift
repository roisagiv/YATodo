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

  private static var container: Container!

  class func configure(application: UIApplication) {
    container = Container { container in
      container.register(TodoNetworkService.self) { _ in
        MoyaTodoNetworkService(log: false)
      }

      container.register(DatabaseWriter.self) { _ in
        let writer = DBFactory.inMemory(log: false)
        do {
          try DBMigrationService.migrate(database: writer)
        } catch {}
        return writer
      }

      container.register(TodoStorageService.self) { resolver in
        GRDBTodoStorageService(database: resolver.resolve(DatabaseWriter.self)!)
      }

      container.register(TodoRepository.self) { resolver in
        TodoRepository(
          storage: resolver.resolve(TodoStorageService.self)!,
          network: resolver.resolve(TodoNetworkService.self)!
        )
      }

      container.register(TodoListViewModel.self) { resolver in
        DefaultTodoListViewModel(repository: resolver.resolve(TodoRepository.self)!)
      }
    }
  }
}
