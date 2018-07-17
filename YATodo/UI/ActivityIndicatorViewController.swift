//
//  ActivityIndicatorViewController.swift
//  YATodo
//
//  Created by Roi Sagiv on 05/04/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import MaterialComponents

protocol ActivityIndicatorViewController: class {
  var activityIndicator: UIView? { get set }
  func displayActivityIndicator()
  func hideActivityIndicator()
}

extension ActivityIndicatorViewController where Self: UIViewController {
  func displayActivityIndicator() {
    let spinnerView = UIView(frame: view.bounds)
    spinnerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    spinnerView.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.3)
    let indicator = MDCActivityIndicator(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
    indicator.startAnimating()
    indicator.center = spinnerView.center

    DispatchQueue.main.async {
      spinnerView.addSubview(indicator)
      self.view.addSubview(spinnerView)
    }
    self.activityIndicator = spinnerView
  }

  func hideActivityIndicator() {
    DispatchQueue.main.async {
      self.activityIndicator?.removeFromSuperview()
    }
  }
}
