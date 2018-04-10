//
//  TodoListViewController.swift
//  YATodo
//
//  Created by Roi Sagiv on 21/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import MaterialComponents
import MaterialDesignSymbol
import RxCocoa
import RxSwift

class TodoListViewController: MDCCollectionViewController {
  fileprivate let appBar = MDCAppBar()
  private let fab = MDCFloatingButton()

  private var titleView: TodoListTitleView?
  fileprivate var spinnerView: UIView?

  private var todos: [TodoModel] = []
  private let disposeBag = DisposeBag()
  fileprivate var viewModel: TodoListViewModel?
  private var router: Router?
  private var dates: Dates?

  // ActivityIndicatorViewController
  var activityIndicator: UIView?

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundColor = Theme.primaryLightColor
    collectionView?.register(cellType: TodoListCellView.self)
    styler.cellStyle = .default
    styler.cellLayoutType = .list

    // AppBar
    addChildViewController(appBar.headerViewController)
    appBar.headerViewController.headerView.trackingScrollView = collectionView
    appBar.addSubviewsToParent()

    let headerView = appBar.headerViewController.headerView
    headerView.canOverExtend = false
    headerView.minMaxHeightIncludesSafeArea = false
    let height: CGFloat = 104
    headerView.maximumHeight = height
    headerView.minimumHeight = height

    titleView = TodoListTitleView(frame: headerView.bounds)
    titleView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    headerView.insertSubview(titleView!, at: 0)

    // FAB
    fab.setTitle(MaterialDesignIcon.add48px, for: .normal)
    fab.setTitleFont(MaterialDesignFont.fontOfSize(24), for: .normal)
    fab.sizeToFit()
    fab.addTarget(self, action: #selector(didTapOnAddNewTodo(_:)), for: .touchUpInside)
    view.addSubview(fab)
    fab.translatesAutoresizingMaskIntoConstraints = false
    fab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
    fab.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0).isActive = true

    viewModel?.loading.drive(onNext: { [weak self] loading in
      guard let `self` = self else { return }
      if loading {
        self.displayActivityIndicator()
      } else {
        self.hideActivityIndicator()
      }
    }).disposed(by: disposeBag)

    viewModel?.todos.drive(onNext: { [weak self] todos in
      self?.todos = todos
      self?.titleView?.configure(tasksCount: todos.count,
                                 date: self?.dates?.today() ?? Date())
      self?.collectionView?.reloadData()
    }).disposed(by: disposeBag)

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
    titleView?.configure(tasksCount: todos.count, date: dates?.today() ?? Date())
  }

  @objc fileprivate func didTapOnAddNewTodo(_ sender: UIButton) {
    router?.navigate(to: .new, from: self)
  }

}

extension TodoListViewController {
  override func collectionView(_ collectionView: UICollectionView, cellHeightAt indexPath: IndexPath) -> CGFloat {
    return MDCCellDefaultTwoLineHeight
  }

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return todos.count
  }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: TodoListCellView = collectionView.dequeueReusableCell(for: indexPath)
    let todo = todos[indexPath.row]
    cell.configure(todo: todo) { [weak self] todo in
      guard let `self` = self else { return }
      self.viewModel?.toggle(todo: todo)
        .drive(onCompleted: {})
        .disposed(by: self.disposeBag)
    }

    return cell
  }

  override func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
    let todo = todos[indexPath.row]
    router?.navigate(to: .edit(id: todo.id), from: self)
  }

  override func collectionViewAllowsSwipe(toDismissItem collectionView: UICollectionView) -> Bool {
    return true
  }

  override func collectionView(_ collectionView: UICollectionView,
                               canSwipeToDismissItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  override func collectionView(_ collectionView: UICollectionView,
                               didEndSwipeToDismissItemAt indexPath: IndexPath) {
    let todo = todos[indexPath.row]
    todos.remove(at: indexPath.row)
    collectionView.reloadData()

    viewModel?.delete(todo: todo).drive().disposed(by: disposeBag)
  }

}

extension TodoListViewController {
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == appBar.headerViewController.headerView.trackingScrollView {
      appBar.headerViewController.headerView.trackingScrollDidScroll()
    }
  }

  override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView == appBar.headerViewController.headerView.trackingScrollView {
      appBar.headerViewController.headerView.trackingScrollDidEndDecelerating()
    }
  }

  override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if scrollView == appBar.headerViewController.headerView.trackingScrollView {
      let headerView = appBar.headerViewController.headerView
      headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
    }
  }

  override func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                          withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    if scrollView == appBar.headerViewController.headerView.trackingScrollView {
      let headerView = appBar.headerViewController.headerView
      headerView.trackingScrollWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
  }

  override var childViewControllerForStatusBarStyle: UIViewController? {
    return appBar.headerViewController
  }
}

extension TodoListViewController {
  class func new(viewModel: TodoListViewModel,
                 router: Router,
                 dates: Dates) -> UIViewController {
    let vc = Storyboards.viewController(from: self)
    vc.viewModel = viewModel
    vc.router = router
    vc.dates = dates
    return vc
  }
}

extension TodoListViewController: ActivityIndicatorViewController {
}
