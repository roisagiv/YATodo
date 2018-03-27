//
//  TodoItemViewController.swift
//  YATodo
//
//  Created by Roi Sagiv on 26/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import MaterialComponents
import RxSwift
import UIKit

class TodoItemViewController: UIViewController {
  private let appBar = MDCAppBar()

  @IBOutlet private var todoNameTextField: MDCMultilineTextField!
  private var titleController: MDCTextInputController!

  private var viewModel: TodoItemViewModel?
  private var todo: TodoModel?
  private let disposeBag = DisposeBag()

  // ActivityIndicatorViewController
  var activityIndicator: UIView?

  override func viewDidLoad() {
    super.viewDidLoad()
    title = ""

    view.backgroundColor = Theme.primaryLightColor

    // AppBar
    Theme.apply(appBar: appBar)
    addChildViewController(appBar.headerViewController)
    appBar.addSubviewsToParent()
    appBar.navigationBar.rightBarButtonItems = []
    appBar.navigationBar.titleTextAttributes = [
      NSAttributedStringKey.foregroundColor: Theme.tintTextColor,
      NSAttributedStringKey.font: MDCTypography.headlineFont()
    ]
    let saveButton = UIBarButtonItem(image: Icons.save(size: CGSize(width: 24, height: 24)),
                                     style: .done,
                                     target: self,
                                     action: #selector(saveAction))
    appBar.navigationBar.rightBarButtonItems?.append(saveButton)
    let headerView = appBar.headerViewController.headerView
    headerView.canOverExtend = false
    headerView.minMaxHeightIncludesSafeArea = false

    titleController = MDCTextInputControllerFullWidth(textInput: todoNameTextField)
    Theme.apply(textController: titleController)
    titleController.textInput?.textColor = Theme.tintSecondaryTextColor

    viewModel?.todo.drive(onNext: { [weak self] todo in
      self?.todo = todo
      self?.todoNameTextField.text = todo.title
    })
      .disposed(by: disposeBag)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
    Theme.applyGradient(view: appBar.headerViewController.headerView)
  }

  @objc private func saveAction() {

    displayActivityIndicator()
    viewModel?.save(todo: TodoModel(id: todo?.id ?? 0,
                                    title: todoNameTextField.text ?? "",
                                    completed: todo?.completed ?? false))
      .drive(onCompleted: { [weak self] in
        self?.hideActivityIndicator()
        self?.navigationController?.popViewController(animated: true)
      }).disposed(by: disposeBag)
  }
}

extension TodoItemViewController {
  class func new(viewModel: TodoItemViewModel) -> TodoItemViewController {
    let vc = Storyboards.viewController(from: self)
    vc.viewModel = viewModel
    return vc
  }
}

extension TodoItemViewController: ActivityIndicatorViewController {
}
