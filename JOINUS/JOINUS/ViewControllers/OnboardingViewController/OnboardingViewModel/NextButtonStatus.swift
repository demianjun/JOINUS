//
//  NextButtonStatus.swift
//  JOINUS
//
//  Created by Demian on 2021/08/31.
//

import UIKit

class NextButtonStatus {
  func buttonStatus(nextButton: UIButton) {
    
    if nextButton.isEnabled {
      
      nextButton.setTitleColor(.white,
                                    for: .normal)
      nextButton.backgroundColor = UIColor.joinusColor.genderSelectedBlue
      
    } else {
      
      nextButton.setTitleColor(UIColor.lightGray,
                                    for: .normal)
      nextButton.backgroundColor = UIColor.joinusColor.genderDeselectedGray
    }
  }
}
