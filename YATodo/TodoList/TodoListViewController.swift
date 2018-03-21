//
//  TodoListViewController.swift
//  YATodo
//
//  Created by Roi Sagiv on 21/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import MaterialComponents
import MaterialDesignSymbol
import Fakery

class TodoListViewController: MDCCollectionViewController {
  fileprivate let appBar = MDCAppBar()
  private var titleView: TodoListTitleView?

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundColor = Theme.primaryLightColor
    collectionView?.register(cellType: TodoListCellView.self)
    styler.cellStyle = .default

    // AppBar
    addChildViewController(appBar.headerViewController)
    appBar.headerViewController.headerView.trackingScrollView = collectionView
    appBar.addSubviewsToParent()

    let headerView = appBar.headerViewController.headerView
    headerView.canOverExtend = false
    headerView.maximumHeight = 104
    headerView.minimumHeight = 104
//    Theme.applyGradient(view: headerView)

    titleView = TodoListTitleView(frame: headerView.bounds)
    titleView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    headerView.insertSubview(titleView!, at: 0)
//    appBar.navigationBar.backgroundColor = UIColor.clear
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
    return 20
  }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: TodoListCellView = collectionView.dequeueReusableCell(for: indexPath)
    if indexPath.row % 2 == 0 {
      cell.imageView?.image = Icons.checkBoxOutline(size: CGSize(width: 24, height: 24))
    } else {
      cell.imageView?.image = Icons.checkBox(size: CGSize(width: 24, height: 24))
    }
    
    let faker = Faker()
    cell.textLabel?.text = faker.lorem.sentence()
    cell.textLabel?.textColor = Theme.tintSecondaryTextColor

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
  class func new() -> UIViewController {
    let className = String(describing: TodoListViewController.self)
    let storyboard = UIStoryboard(name: className, bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: className)
    return vc
  }
}
