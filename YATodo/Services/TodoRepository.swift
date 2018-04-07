//
//  TodoRepository.swift
//  YATodo
//
//  Created by Roi Sagiv on 22/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import RxSwift
import Moya

class TodoRepository {
  private let storage: TodoStorageService
  private let network: TodoNetworkService
  private let disposeBag: DisposeBag

  init(storage: TodoStorageService, network: TodoNetworkService) {
    self.storage = storage
    self.network = network
    self.disposeBag = DisposeBag()
  }

  func all() -> Observable<[TodoModel]> {
    return self.storage
      .all()
      .flatMap { [weak self] (todos) -> Observable<[TodoModel]> in
        guard let `self` = self else {
          return Observable<[TodoModel]>.error(Error.weak)
        }

        if todos.count == 0 {
          return self.network
            .all()
            .asObservable()
            .flatMap { [weak self] (todos) -> Observable<[TodoModel]> in
              guard let `self` = self else {
                return Observable<[TodoModel]>.error(Error.weak)
              }
              return self.storage.save(todos: todos).asObservable()
            }
        } else {
          return Observable<[TodoModel]>.just(todos)
        }
      }
  }

  // swiftlint:disable:next identifier_name
  func get(id: Int) -> Observable<TodoModel> {
    return self.storage
      .get(id: id)
      .flatMap { [weak self] (element) -> Observable<TodoModel> in
        guard let `self` = self else {
          return Observable<TodoModel>.error(Error.weak)
        }
        guard let todo = element else {
          return self.network.get(id: id).asObservable()
        }
        return Observable<TodoModel>.just(todo)
      }
  }

  func save(todo: TodoModel) -> Single<TodoModel> {
    let operation: Single<TodoModel> = todo.id > 0 ?
      self.network.update(todo: todo) :
      self.network.create(title: todo.title, completed: todo.completed)

    return operation
      .flatMap { [weak self] (element) -> Single<TodoModel> in
        guard let `self` = self else {
          return Single<TodoModel>.error(Error.weak)
        }
        return self.storage.save(todo: element)
      }
  }

  func toggle(todo: TodoModel) -> Single<Void> {
    return self.storage
      .save(todo: TodoModel(id: todo.id, title: todo.title, completed: !todo.completed))
      .flatMap { [weak self] (todo) -> Single<TodoModel> in
        guard let `self` = self else {
          return Single<TodoModel>.error(Error.weak)
        }
        return self.network.update(todo: todo)
      }
      .flatMap { _ in Single<Void>.just(()) }
  }

  // swiftlint:disable:next identifier_name
  func delete(id: Int) -> Single<Void> {
    return self.storage
      .delete(id: id)
      .flatMap { [weak self] (_) -> Single<Moya.Response> in
        guard let `self` = self else {
          return Single<Moya.Response>.error(Error.weak)
        }
        return self.network.delete(id: id)
      }
      .flatMap { _ in Single<Void>.just(()) }
  }

  enum Error: Swift.Error {
    case weak
    case notFound
  }
}
