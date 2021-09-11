//
//  RangeTierButton.swift
//  JOINUS
//
//  Created by Demian on 2021/09/12.
//

import UIKit

class RangeTierButton: UIButton {
  override var isSelected: Bool {
    didSet {
      self.buttonTitleLabel.textColor = UIColor.joinusColor.joinBlue
      self.selectedMarkImage.isHidden = false
    }
  }
  
  private let buttonTitleLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 14)
    $0.textColor = .black
  }
  
  private let selectedMarkImage = UIImageView().then {
    $0.image = UIImage(named: "tierSelectedMark")
    $0.isHidden = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  private func setupView() {
    [buttonTitleLabel, selectedMarkImage].forEach { self.addSubview($0) }
    
    buttonTitleLabel.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
    }
    
    selectedMarkImage.snp.makeConstraints {
      $0.width.equalTo(CommonLength.shared.width(15))
      $0.height.equalTo(CommonLength.shared.height(10))
      $0.leading.equalTo(buttonTitleLabel.snp.trailing).offset(CommonLength.shared.width(18))
      $0.trailing.equalToSuperview()
    }
  }
  
  func useButtonTitleLabel() -> UILabel {
    return self.buttonTitleLabel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
