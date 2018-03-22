//
//  TodoListCellView.swift
//  YATodo
//
//  Created by Roi Sagiv on 22/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import MaterialComponents
import Reusable

class TodoListCellView: MDCCollectionViewTextCell, Reusable {

  func configure(todo: TodoModel) {
    if todo.completed {
      imageView?.image = Icons.checkBoxOutline(size: CGSize(width: 24, height: 24))
    } else {
      imageView?.image = Icons.checkBox(size: CGSize(width: 24, height: 24))
    }

    textLabel?.text = todo.title
    textLabel?.textColor = Theme.tintSecondaryTextColor
  }
}
