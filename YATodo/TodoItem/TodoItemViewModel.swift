//
//  TodoItemViewModel.swift
//  YATodo
//
//  Created by Roi Sagiv on 27/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import RxSwift
import RxCocoa

protocol TodoItemViewModel {
  var todo: Driver<TodoModel> { get }

  func save(todo: TodoModel) -> Driver<Void>
}

class DefaultTodoItemViewModel: TodoItemViewModel {
  private let repository: TodoRepository
  private let todoId: Int?

  // swiftlint:disable:next identifier_name
  init(repository: TodoRepository, id: Int?) {
    self.repository = repository
    self.todoId = id
  }

  convenience init(repository: TodoRepository) {
    self.init(repository: repository, id: nil)
  }

  var todo: Driver<TodoModel> {
    let empty = TodoModel(id: 0, title: "", completed: false)

    guard let id = todoId else {
      return Driver.just(empty)
    }

    return self.repository.get(id: id).asDriver(onErrorJustReturn: empty)
  }

  func save(todo: TodoModel) -> Driver<Void> {
    return self.repository
      .save(todo: todo)
      .flatMap { _ in Single<Void>.just(()) }
      .asDriver(onErrorJustReturn: ())
  }
}
