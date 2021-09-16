//
//  ToggleButton.swift
//  JOINUS
//
//  Created by Demian on 2021/09/12.
//

import UIKit

class ToggleButton: UIButton {
  override var isSelected: Bool{
    didSet {
      
      if self.isSelected {
        
        self.backgroundColor = UIColor.joinusColor.genderSelectedBlue
        
      } else {
        
        self.backgroundColor = UIColor.joinusColor.genderDeselectedGray
      }
    }
  }
  
  init(set title: String) {
    super.init(frame: .zero)
    self.setTitle(title,
                for: .normal)
    self.setTitleColor(UIColor.lightGray,
                     for: .normal)
    self.setTitleColor(UIColor.white,
                     for: .selected)
    self.backgroundColor = UIColor.joinusColor.genderDeselectedGray
    self.titleLabel?.font = UIFont.joinuns.font(size: 13)
    self.layer.cornerRadius = CommonLength.shared.height(30) / 2
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
