//
//  TodoListViewControllerSpec.swift
//  YATodo
//
//  Created by Roi Sagiv on 25/03/2018.
// Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import OHHTTPStubs
import Quick
import RxCocoa
import RxSwift
@testable import YATodo

class TodoListViewControllerSpec: QuickSpec {
  override func spec() {
    describe("viewDidLoad") {

      it("displays the loading state") {
        let viewModel = TestableViewModel()
        let vc = TodoListViewController.new(viewModel: viewModel)
        TestAppDelegate.displayAsRoot(viewController: vc)
        viewModel.loadingSubject.onNext(true)
        Sync.tick()
        expect(vc).to(haveValidDynamicSizeSnapshot(sizes: Device.sizes))
//        expect(vc).to(recordDynamicSizeSnapshot(sizes: Device.sizes))
      }

      it("displays the todo list") {
        let data = JSONs.codableFromFile("jsonplaceholder-todos-success", type: [TodoModel].self)
        let viewModel = TestableViewModel()
        let vc = TodoListViewController.new(viewModel: viewModel)
        TestAppDelegate.displayAsRoot(viewController: vc)
        viewModel.todoSubject.onNext(data)
        Sync.tick()
        expect(vc).to(haveValidDynamicSizeSnapshot(sizes: Device.sizes))
//        expect(vc).to(recordDynamicSizeSnapshot(sizes: Device.sizes))
      }
    }

    describe("integration") {

      it("displays list of todos") {
        var httpCalled = 0
        OHHTTPStubs.stubRequests(passingTest: { $0.url?.path == "/todos" }) { _ in
          httpCalled += 1
          let path = OHPathForFile("jsonplaceholder-todos-success.json", TodoRepositorySpec.self)!
          return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: nil)
        }

        Injector.configure(application: UIApplication.shared)
        let viewModel = Injector.todoListViewModel()
        let vc = TodoListViewController.new(viewModel: viewModel)
        TestAppDelegate.displayAsRoot(viewController: vc)
        expect(httpCalled).toEventually(equal(1))
        Sync.tick()
        expect(vc).to(haveValidDynamicSizeSnapshot(sizes: Device.sizes))
//        expect(vc).to(recordDynamicSizeSnapshot(sizes: Device.sizes))
      }
    }
  }

  class TestableViewModel: TodoListViewModel {

    let todoSubject = PublishSubject<[TodoModel]>()
    let loadingSubject = PublishSubject<Bool>()

    var todos: Driver<[TodoModel]> {
      return todoSubject.asDriver(onErrorJustReturn: [])
    }

    var loading: Driver<Bool> {
      return loadingSubject.asDriver(onErrorJustReturn: false)
    }
  }
}
