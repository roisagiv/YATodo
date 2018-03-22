//
//  TodoStorageService.swift
//  YATodo
//
//  Created by Roi Sagiv on 22/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import GRDB
import RxGRDB
import RxSwift

protocol TodoStorageService {
  func all() -> Observable<[TodoModel]>
  func save(todos: [TodoModel]) -> Single<[TodoModel]>
}

struct GRDBTodoStorageService: TodoStorageService {
  private let database: DatabaseWriter

  init(database: DatabaseWriter) {
    self.database = database
  }

  func all() -> Observable<[TodoModel]> {
    return TodoModel.all().rx
      .fetchAll(in: self.database)
      .observeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
  }

  func save(todos: [TodoModel]) -> Single<[TodoModel]> {
    return Single<[TodoModel]>.deferred {
      do {
        try self.database.write { writer in
          try writer.inTransaction {
            for todo in todos {
              try todo.insert(writer)
            }

            return .commit
          }
        }
        return .just(todos)
      } catch let error {
        return .error(error)
      }
    }
  }
}
