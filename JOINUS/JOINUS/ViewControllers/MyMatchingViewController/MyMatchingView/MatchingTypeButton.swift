//
//  MatchingTypeButton.swift
//  JOINUS
//
//  Created by Demian on 2021/09/14.
//

import UIKit

class MatchinTypeButton: UIButton {
  override var isSelected: Bool {
    didSet {
      if self.isSelected {
        
        self.overBarView.backgroundColor = .black
        self.matchingTypeLabel.textColor = .black
        
      } else {
        
        self.overBarView.backgroundColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
        self.matchingTypeLabel.textColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
      }
    }
  }
  
  // MARK: View
  private let overBarView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
  }
  
  private let matchingTypeLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 19)
    $0.textAlignment = .center
    $0.textColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
  }
  
  // MARK: initialized
  init(type: String) {
    super.init(frame: .zero)
    self.matchingTypeLabel.text = type
    self.backgroundColor = .white
    self.setupView()
  }
  
  private func setupView() {
    [overBarView, matchingTypeLabel].forEach { self.addSubview($0) }
    
    overBarView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(2))
    }
    
    matchingTypeLabel.snp.makeConstraints {
      $0.top.equalTo(overBarView.snp.bottom).offset(CommonLength.shared.height(10))
      $0.center.equalToSuperview()
      $0.bottom.equalTo(-CommonLength.shared.height(12))
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
