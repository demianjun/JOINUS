//
//  JoinusButton.swift
//  Pods
//
//  Created by Demian on 2021/09/09.
//

import UIKit

class JoinusButton: UIButton {
  override var isEnabled: Bool {
    didSet {
      if self.isEnabled {
        
        self.setTitleColor(.white,
                           for: .normal)
        self.backgroundColor = UIColor.joinusColor.joinBlue
        
      } else {
        
        self.setTitleColor(UIColor.joinusColor.defaultPhotoGray,
                           for: .normal)
        self.backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
      }
    }
  }

  init(title: String, titleColor: UIColor, backGroundColor: UIColor) {
    super.init(frame: .zero)
    self.setTitle(title,
                  for: .normal)
    self.setTitleColor(titleColor,
                       for: .normal)
    self.titleLabel?.font = UIFont.joinuns.font(size: 17)
    self.backgroundColor = backGroundColor
    self.layer.cornerRadius = 2
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
