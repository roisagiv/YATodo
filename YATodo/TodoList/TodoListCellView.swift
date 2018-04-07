//
//  TodoListCellView.swift
//  YATodo
//
//  Created by Roi Sagiv on 22/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import MaterialComponents
import Reusable

class TodoListCellView: MDCCollectionViewCell, Reusable, NibLoadable {

  typealias DidToggleTodo = (TodoModel) -> Void

  @IBOutlet private var textLabel: UILabel?
  @IBOutlet private var checkBoxButton: MDCFlatButton?
  private var toggleCallback: DidToggleTodo?
  private var todo: TodoModel?

  private let iconSize = CGSize(width: 24, height: 24)

  func configure(todo: TodoModel, didToggleTodo: @escaping DidToggleTodo) {
    cancelInkAnimations()
    self.todo = todo
    toggleCallback = didToggleTodo

    let image = todo.completed
      ? Icons.checkBox(size: iconSize)
      : Icons.checkBoxOutline(size: iconSize)

    checkBoxButton?.tintColor = todo.completed
      ? Theme.secondaryColor
      : Theme.tintSecondaryTextColor

    checkBoxButton?.setTitleColor(checkBoxButton?.tintColor, for: .normal)
    checkBoxButton?.setImage(image, for: .normal)
    textLabel?.text = todo.title
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    cancelInkAnimations()
    checkBoxButton?.imageView?.contentMode = .center
    checkBoxButton?.imageEdgeInsets = UIEdgeInsets.zero
    if let checkBoxButton = checkBoxButton {
      bringSubview(toFront: checkBoxButton)
    }

    textLabel?.textColor = Theme.tintSecondaryTextColor
    textLabel?.font = MDCTypography.subheadFont()
    textLabel?.alpha = MDCTypography.subheadFontOpacity()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    cancelInkAnimations()
  }

  @IBAction private func didTapCheckBox(_ sender: UIButton) {
    guard let todo = self.todo, let toggleCallback = self.toggleCallback else {
      return
    }
    toggleCallback(todo)
  }

  private func cancelInkAnimations() {
    guard let checkBoxButton = self.checkBoxButton else {
      return
    }
    let inkView = checkBoxButton.subviews[0] as? MDCInkView
    inkView?.cancelAllAnimations(animated: false)
  }
}
