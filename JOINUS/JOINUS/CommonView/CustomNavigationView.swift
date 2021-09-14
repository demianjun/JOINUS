//
//  CustomNavigationView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/10.
//

import UIKit

class CustomNavigationView: UIView {
  private let partition = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
//    self.layer.shadowOffset = CGSize(width: 0, height: 1)
//    self.layer.shadowColor = #colorLiteral(red: 0.4509803922, green: 0.4509803922, blue: 0.4509803922, alpha: 1)
//    self.layer.shadowOpacity = 0.5
    self.addSubview(self.partition)
    
    partition.snp.makeConstraints {
      $0.bottom.leading.trailing.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

