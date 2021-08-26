//
//  CommonFont.swift
//  JOINUS
//
//  Created by Demian on 2021/08/16.
//

import UIKit

struct CommonFont {
  static let shared = CommonFont()
  
  func font_Regular(_ float: CGFloat) -> UIFont {
    guard let font = UIFont(name: "AppleSDGothicNeo-Regular",
                            size: CommonLength.shared.width(float)) else { return UIFont() }
    return font
  }
  
  func font_Bold(_ float: CGFloat) -> UIFont {
    guard let font = UIFont(name: "AppleSDGothicNeo-Bold",
                            size: CommonLength.shared.width(float)) else { return UIFont() }
    return font
  }
}

extension UIFont {
  
  struct joinuns {
    /// font : Noto Sans KR - Bold
    static func font(size: CGFloat) -> UIFont {
      guard let font = UIFont(name: "NotoSansKR-Bold",
                              size: CommonLength.shared.width(size)) else { return UIFont() }
      return font
    }
  }
}

