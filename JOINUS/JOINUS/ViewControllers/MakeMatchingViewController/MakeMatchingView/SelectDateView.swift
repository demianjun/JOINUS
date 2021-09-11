//
//  SelectDateView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/12.
//

import UIKit

class SelectDateView: UIView {
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  private func setupView() {
    [].forEach { self.addSubview($0) }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
