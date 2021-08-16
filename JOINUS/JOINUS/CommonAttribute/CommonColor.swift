//
//  CommonColor.swift
//  JOINUS
//
//  Created by Demian on 2021/08/16.
//

import UIKit

struct CommonColor {
  
  static let shared = CommonColor()
  
  func customColor(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat? = nil) -> UIColor {
    return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: alpha ?? 1.0)
  }
}

extension UIColor {
  struct joinusColor {
    static let joinBlue = CommonColor.shared.customColor(r: 52, g: 120, b: 246)
  }
}
