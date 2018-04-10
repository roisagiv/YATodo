//
//  TodoListTitleView.swift
//  YATodo
//
//  Created by Roi Sagiv on 22/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import MaterialComponents
import Reusable

class TodoListTitleView: UIView, NibOwnerLoadable {
  @IBOutlet private var dateLabel: UILabel!
  @IBOutlet private var monthLabel: UILabel!
  @IBOutlet private var todoCountLabel: UILabel!
  @IBOutlet private var contentView: UIView!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    loadNibContent()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    loadNibContent()
  }

  func configure(tasksCount: Int, date: Date) {
    Theme.applyGradient(view: self)

    let dayFormatter = DateFormatter()
    dayFormatter.dateFormat = "EEEE"
    let day = ordinalDayFrom(date: date)
    dateLabel.text = "\(dayFormatter.string(from: date)), \(day)"
    dateLabel.textColor = Theme.tintTextColor
    dateLabel.font = MDCTypography.headlineFont()
    dateLabel.alpha = MDCTypography.headlineFontOpacity()

    let monthFormatter = DateFormatter()
    monthFormatter.dateFormat = "MMMM"
    monthLabel.text = monthFormatter.string(from: date)
    monthLabel.textColor = Theme.tintSecondaryTextColor
    monthLabel.font = MDCTypography.body2Font()
    monthLabel.alpha = MDCTypography.body2FontOpacity()

    todoCountLabel.text = "\(tasksCount) Tasks"
    todoCountLabel.textColor = Theme.tintSecondaryTextColor
    todoCountLabel.font = MDCTypography.body2Font()
    todoCountLabel.alpha = MDCTypography.body2FontOpacity()
  }

  private func ordinalDayFrom(date: Date) -> String {
    let calendar = Calendar.current
    let dateComponents = calendar.component(.day, from: date)
    let numberFormatter = NumberFormatter()

    numberFormatter.numberStyle = .ordinal

    return numberFormatter.string(from: dateComponents as NSNumber) ?? ""
  }
}
