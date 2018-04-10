//
//  Router.swift
//  YATodo
//
//  Created by Roi Sagiv on 31/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import UIKit
import URLPatterns

enum Route: Equatable {
  static func == (lhs: Route, rhs: Route) -> Bool {
    switch (lhs, rhs) {
    case (.list, .list):
      return true
    case (.new, .new):
      return true
    case (.edit(let lhsId), .edit(let rhsId)):
      return lhsId == rhsId
    default:
      return false
    }
  }

  case list
  case edit(id: Int)
  case new

  var viewController: UIViewController {
    switch self {
    case .list:
      let viewModel = Injector.todoListViewModel()
      let router = Injector.router()
      let dates = Injector.dates()
      return TodoListViewController.new(
        viewModel: viewModel, router: router, dates: dates
      )

    case .new:
      let viewModel = Injector.todoItemViewModel(id: nil)
      return TodoItemViewController.new(viewModel: viewModel)

    case .edit(let id):
      let viewModel = Injector.todoItemViewModel(id: id)
      return TodoItemViewController.new(viewModel: viewModel)
    }
  }

  init?(url: URL) {
    switch url.countedPathComponents() {
    case .n0, .n1(""), .n1("todos"):
      self = .list
    case .n2("todos", "new"):
      self = .new
    case .n2("todos", let id):
      self = .edit(id: Int(id) ?? 0)
    default:
      return nil
    }
  }
}

protocol Router {

  func navigate(to route: Route, from window: UIWindow)
  func navigate(to route: Route, from viewController: UIViewController)
}

struct DefaultRouter: Router {

  func navigate(to route: Route, from window: UIWindow) {
    let nc = UINavigationController(rootViewController: route.viewController)
    window.rootViewController = nc
  }

  func navigate(to route: Route, from viewController: UIViewController) {
    viewController.navigationController?
      .pushViewController(route.viewController, animated: true)
  }
}
