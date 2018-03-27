//
//  TodoItemViewControllerSpec.swift
//  YATodo
//
//  Created by Roi Sagiv on 06/04/2018.
// Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import Quick
import RxCocoa
import RxSwift
@testable import YATodo

class TodoItemViewControllerSpec: QuickSpec {
  override func spec() {

    describe("viewDidLoad") {
      it("populate the views with todo") {
        let todo = TodoModel(id: 5, title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", completed: false)
        let viewModel = TestableViewModel()
        viewModel.todoSubject.onNext(todo)

        let vc = TodoItemViewController.new(viewModel: viewModel)
        TestAppDelegate.displayAsRoot(viewController: vc)
        Sync.tick()

        expect(vc).to(haveValidDynamicSizeSnapshot(sizes: Device.sizes, usesDrawRect: true))
//        expect(vc).to(recordDynamicSizeSnapshot(sizes: Device.sizes, usesDrawRect: true))
      }
    }
  }

  class TestableViewModel: TodoItemViewModel {
    let defaultTodo: TodoModel
    let todoSubject: BehaviorSubject<TodoModel>

    init() {
      self.defaultTodo = TodoModel(id: 0, title: "", completed: true)
      self.todoSubject = BehaviorSubject<TodoModel>(value: self.defaultTodo)
    }

    var todo: Driver<TodoModel> {
      return self.todoSubject
        .asDriver(onErrorJustReturn: self.defaultTodo)
        .debug()
    }

    func save(todo: TodoModel) -> Driver<Void> {
      return Driver.just(())
    }

  }
}
