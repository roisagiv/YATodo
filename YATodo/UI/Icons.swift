//
//  Icons.swift
//  YATodo
//
//  Created by Roi Sagiv on 22/03/2018.
//  Copyright © 2018 Roi Sagiv. All rights reserved.
//

import MaterialDesignSymbol

struct Icons {
  static func checkBoxOutline(size: CGSize) -> UIImage {
    let symbol: MaterialDesignSymbol = MaterialDesignSymbol(
      text: MaterialDesignIcon.checkBoxOutlineBlank24px,
      size: size.width
    )
    symbol.addAttribute(attributeName: NSAttributedStringKey.foregroundColor,
                        value: Theme.tintSecondaryTextColor)
    return symbol.image(size: size)
  }
  
  static func checkBox(size: CGSize) -> UIImage {
    let symbol: MaterialDesignSymbol = MaterialDesignSymbol(
      text: MaterialDesignIcon.checkBox24px,
      size: size.width
    )
    symbol.addAttribute(attributeName: NSAttributedStringKey.foregroundColor,
                        value: Theme.secondaryColor)
    return symbol.image(size: size)
  }
}
