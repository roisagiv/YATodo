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
  
  func configure() {
    Theme.applyGradient(view: self)
    
    dateLabel.text = "Thursday, 10th"
    dateLabel.textColor = Theme.tintTextColor
    dateLabel.font = MDCTypography.headlineFont()
    dateLabel.alpha = MDCTypography.headlineFontOpacity()
    
    monthLabel.text = "December"
    monthLabel.textColor = Theme.tintSecondaryTextColor
    monthLabel.font = MDCTypography.body2Font()
    monthLabel.alpha = MDCTypography.body2FontOpacity()
    
    todoCountLabel.text = "12 Tasks"
    todoCountLabel.textColor = Theme.tintSecondaryTextColor
    todoCountLabel.font = MDCTypography.body2Font()
    todoCountLabel.alpha = MDCTypography.body2FontOpacity()
  }
}
