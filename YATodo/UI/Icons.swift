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
    return image(
      from: MaterialDesignIcon.checkBoxOutlineBlank48px,
      size: size,
      color: Theme.tintSecondaryTextColor
    )
  }

  static func checkBox(size: CGSize) -> UIImage {
    return image(
      from: MaterialDesignIcon.checkBox48px,
      size: size,
      color: Theme.secondaryColor
    )
  }

  static func save(size: CGSize) -> UIImage {
    return image(
      from: MaterialDesignIcon.save48px,
      size: size,
      color: Theme.tintTextColor
    )
  }

  private static func image(from text: String, size: CGSize, color: UIColor) -> UIImage {
    let symbol: MaterialDesignSymbol = MaterialDesignSymbol(
      text: text,
      size: size.width
    )
    symbol.addAttribute(
      attributeName: NSAttributedStringKey.foregroundColor,
      value: color
    )
    return symbol.image(size: size)
  }

}
