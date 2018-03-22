//
//  TodoRepository.swift
//  YATodo
//
//  Created by Roi Sagiv on 22/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import RxSwift

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
    return self.storage.all().flatMap { [weak self] (todos) -> Observable<[TodoModel]> in
      guard let `self` = self else {
        return Observable<[TodoModel]>.error(Error.weak)
      }

      if todos.count == 0 {
        return self.network.all().asObservable().flatMap { [weak self] (todos) -> Observable<[TodoModel]> in
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

  enum Error: Swift.Error {
    case weak
  }
}
