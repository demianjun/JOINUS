//
//  CommonLength.swift
//  JOINUS
//
//  Created by Demian on 2021/08/16.
//

import UIKit

struct CommonLength {
  
  static let shared = CommonLength()
  
  func width(_ float: CGFloat) -> CGFloat {
    return UIScreen.main.bounds.width * (float / 375)
  }
  
  func height(_ float: CGFloat) -> CGFloat {
    return UIScreen.main.bounds.height * (float / 667)
  }
}
