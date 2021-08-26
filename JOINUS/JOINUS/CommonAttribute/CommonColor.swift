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
    static let joinBlue = CommonColor.shared.customColor(r: 52, g: 120, b: 246),
               genderSelectedBlue = joinBlue,
               genderDeselectedGray = CommonColor.shared.customColor(r: 112, g: 112, b: 112)
    
    let temp = #colorLiteral(red: 0.4391763508, green: 0.4392417669, blue: 0.4391556382, alpha: 1)
  }
}


