//
//  JoinusButton.swift
//  Pods
//
//  Created by Demian on 2021/09/09.
//

import UIKit

class JoinusButton: UIButton {

  init(title: String, titleColor: UIColor, backGroundColor: UIColor) {
    super.init(frame: .zero)
    self.setTitle(title,
                  for: .normal)
    self.setTitleColor(titleColor,
                       for: .normal)
    self.backgroundColor = backGroundColor
    self.layer.cornerRadius = 2
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
