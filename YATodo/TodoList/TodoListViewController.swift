//
//  TodoListViewController.swift
//  YATodo
//
//  Created by Roi Sagiv on 21/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Fakery
import MaterialComponents
import MaterialDesignSymbol
import RxCocoa
import RxSwift

class TodoListViewController: MDCCollectionViewController {
  fileprivate let appBar = MDCAppBar()
  private var titleView: TodoListTitleView?
  fileprivate var spinnerView: UIView?

  private var todos: [TodoModel] = []
  private let disposeBag = DisposeBag()
  fileprivate var viewModel: TodoListViewModel?

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundColor = Theme.primaryLightColor
    collectionView?.register(cellType: TodoListCellView.self)
    styler.cellStyle = .default

    // AppBar
    addChildViewController(appBar.headerViewController)
    appBar.headerViewController.headerView.trackingScrollView = collectionView
    appBar.addSubviewsToParent()

    let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
    let height = 104 + (insets?.top ?? 0.0)
    let headerView = appBar.headerViewController.headerView
    headerView.canOverExtend = false
    headerView.maximumHeight = height
    headerView.minimumHeight = height

    titleView = TodoListTitleView(frame: headerView.bounds)
    titleView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    headerView.insertSubview(titleView!, at: 0)

    viewModel?.loading.drive(onNext: { [weak self] loading in
      guard let `self` = self else { return }
      if loading {
        self.spinnerView = self.displaySpinner()
      } else {
        guard let spinnerView = self.spinnerView else { return }
        self.removeSpinner(spinnerView)
      }
    }).disposed(by: disposeBag)

    viewModel?.todos.drive(onNext: { [weak self] todos in
      self?.todos = todos
      self?.collectionView?.reloadData()
    }).disposed(by: disposeBag)

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
    titleView?.configure()
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
    cell.configure(todo: todo)

    return cell
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
  class func new(viewModel: TodoListViewModel) -> UIViewController {
    let className = String(describing: TodoListViewController.self)
    let storyboard = UIStoryboard(name: className, bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: className)
    let todoListVc = vc as? TodoListViewController
    todoListVc?.viewModel = viewModel
    return vc
  }
}

extension TodoListViewController {
  func displaySpinner() -> UIView {
    let spinnerView = UIView(frame: view.bounds)
    spinnerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    spinnerView.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.3)
    let ai = MDCActivityIndicator(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
    ai.startAnimating()
    ai.center = spinnerView.center
    Theme.apply(activityIndicator: ai)

    DispatchQueue.main.async {
      spinnerView.addSubview(ai)
      self.view.addSubview(spinnerView)
    }
    return spinnerView
  }

  func removeSpinner(_ spinner: UIView) {
    DispatchQueue.main.async {
      spinner.removeFromSuperview()
    }
  }
}
