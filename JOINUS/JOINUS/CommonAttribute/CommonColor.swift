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
    static let joinBlue = CommonColor.shared.customColor(r: 0, g: 122, b: 255),
               genderSelectedBlue = joinBlue,
               genderDeselectedGray = CommonColor.shared.customColor(r: 112, g: 112, b: 112),
               gameSelectGreen = CommonColor.shared.customColor(r: 0, g: 253, b: 127, alpha: 0.6),
               gameIdTextFieldBgGray = CommonColor.shared.customColor(r: 17, g: 17, b: 17, alpha: 0.13),
               gameIdTextFieldPlaceholderGray = CommonColor.shared.customColor(r: 17, g: 17, b: 17, alpha: 0.3),
               tierGray = gameIdTextFieldPlaceholderGray,
               defaultPhotoGray = CommonColor.shared.customColor(r: 17, g: 17, b: 17, alpha: 0.6),
               defaultPhotoButtonGray = gameIdTextFieldBgGray,
               defaultImagePink = CommonColor.shared.customColor(r: 255, g: 0, b: 140),
               actionSheetGray = CommonColor.shared.customColor(r: 255, g: 255, b: 255, alpha: 0.6),
               customBlack = CommonColor.shared.customColor(r: 17, g: 17, b: 17),
               newPink = CommonColor.shared.customColor(r: 255, g: 0, b: 140)
    
    let temp = #colorLiteral(red: 0.8783445954, green: 0.8784921765, blue: 0.8783251643, alpha: 1)
  }
}

