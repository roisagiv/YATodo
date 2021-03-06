//
//  Theme.swift
//  YATodo
//
//  Created by Roi Sagiv on 21/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import Hue
import MaterialComponents

struct Theme {
  static let primaryColor = UIColor(hex: "#d2d3e3")
  static let primaryLightColor = UIColor(hex: "#fefeff")
  static let primaryDarkColor = UIColor(hex: "#a1a2b1")
  static let primaryTextColor = UIColor.black
  static let secondaryColor = UIColor(hex: "#f57173")
  static let secondaryLightColor = UIColor(hex: "#ffa3a2")
  static let secondaryDarkColor = UIColor(hex: "#be4048")
  static let secondaryTextColor = UIColor.black

  static let tintTextColor = UIColor(hex: "#5a5ee7")
  static let tintSecondaryTextColor = UIColor(hex: "#8f8da5")

  private static let colorScheme = MDCBasicColorScheme(primaryColor: Theme.primaryColor,
                                                       primaryLightColor: Theme.primaryLightColor,
                                                       primaryDarkColor: Theme.primaryDarkColor,
                                                       secondaryColor: Theme.secondaryColor,
                                                       secondaryLightColor: Theme.secondaryLightColor,
                                                       secondaryDarkColor: Theme.secondaryDarkColor)

  static func applyGlobaly() {
    MDCIcons.ic_arrow_backUseNewStyle(true)
    apply(activityIndicator: MDCActivityIndicator.appearance())
    apply(fab: MDCFloatingButton.appearance())
    MDCFlexibleHeaderColorThemer.apply(colorScheme, to: MDCFlexibleHeaderView.appearance())
  }

  static func apply(appBar: MDCAppBar) {
    appBar.headerViewController.headerView.backgroundColor = Theme.primaryLightColor
    let navigationBar = appBar.navigationBar
    let gradientLayer: CAGradientLayer = [Theme.primaryLightColor, Theme.primaryColor].gradient { gradient in
      gradient.locations = [0.0, 5.0]
      gradient.bounds = navigationBar.bounds
      gradient.frame = navigationBar.frame

      return gradient
    }

    let tintColor = UIColor(hex: "#5a5ee7")
    navigationBar.layer.insertSublayer(gradientLayer, at: 0)
    navigationBar.tintColor = tintColor
    navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: tintColor]
  }

  static func apply(activityIndicator: MDCActivityIndicator) {
    MDCActivityIndicatorColorThemer.apply(Theme.colorScheme, to: activityIndicator)
  }

  static func apply(fab: MDCFloatingButton) {
    MDCButtonColorThemer.apply(Theme.colorScheme, to: fab)
    fab.tintColor = Theme.primaryTextColor
  }

  static func apply(textController: MDCTextInputController) {
    MDCTextFieldColorThemer.apply(Theme.colorScheme, to: textController)
  }

  static func applyGradient(view: UIView) {
    let gradientLayer: CAGradientLayer = [Theme.primaryLightColor, Theme.primaryColor].gradient { gradient in
      gradient.locations = [0.0, 5.0]
      gradient.bounds = view.bounds
      gradient.frame = view.frame

      return gradient
    }
    view.backgroundColor = UIColor.white
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
}
