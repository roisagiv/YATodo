//
//  Storyboards.swift
//  YATodo
//
//  Created by Roi Sagiv on 27/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import UIKit

struct Storyboards {
  static func viewController<T>(from type: T.Type) -> T where T: UIViewController {
    let className = String(describing: type)
    let storyboard = UIStoryboard(name: className, bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: className)
    // swiftlint:disable:next force_cast
    return vc as! T
  }
}
