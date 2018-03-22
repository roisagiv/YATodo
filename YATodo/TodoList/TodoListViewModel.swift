//
//  TodoListViewModel.swift
//  YATodo
//
//  Created by Roi Sagiv on 24/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import RxCocoa
import RxSwift

protocol TodoListViewModel {
  var todos: Driver<[TodoModel]> { get }
  var loading: Driver<Bool> { get }
}

class DefaultTodoListViewModel: TodoListViewModel {
  private let repository: TodoRepository
  private let loadingSubject: PublishSubject<Bool> = PublishSubject<Bool>()
  private let disposeBag: DisposeBag = DisposeBag()

  init(repository: TodoRepository) {
    self.repository = repository
  }

  var loading: Driver<Bool> {
    return loadingSubject.asDriver(onErrorJustReturn: false)
  }

  var todos: Driver<[TodoModel]> {
    return repository.all()
      .share(replay: 1)
      .observeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
      .asDriver(onErrorJustReturn: [])
      .do(
        onNext: { [weak self] _ in
          guard let `self` = self else {
            return
          }
          self.loadingSubject.onNext(false)
        },
        onSubscribe: { [weak self] in
          guard let `self` = self else {
            return
          }
          self.loadingSubject.onNext(true)
        }
      )
  }
}
