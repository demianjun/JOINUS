//
//  SetJoinPeopleTierView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/11.
//

import UIKit

class SetJoinPeopleTierView: UIView {
  // MARK: View
  private let titleLabel = UILabel().then {
    $0.text = "참가자 티어"
    $0.textColor = .black
    $0.font = UIFont.joinuns.font(size: 17)
  }
  
  private let showSettingTierLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 17)
    $0.textColor = UIColor.joinusColor.defaultPhotoGray
  }
  
  private let changeTierButton = UIButton().then {
    $0.setTitle("변경",
                for: .normal)
    $0.setTitleColor(UIColor.joinusColor.joinBlue,
                     for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 17)
  }
  
  // MARK: Initialized
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  private func setupView() {
    [titleLabel, showSettingTierLabel, changeTierButton].forEach { self.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(20))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
    }
    
    showSettingTierLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(CommonLength.shared.height(10))
      $0.leading.equalTo(titleLabel)    
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(20))
    }
    
    changeTierButton.snp.makeConstraints {
      $0.centerY.equalTo(showSettingTierLabel)
      $0.leading.equalTo(showSettingTierLabel.snp.trailing).offset(CommonLength.shared.width(10))
      $0.width.equalTo(CommonLength.shared.width(35))
      $0.height.equalTo(CommonLength.shared.height(25))
    }
  }
  
  func useChangeTierButton() -> UIButton {
    return self.changeTierButton
  }
  
  func useShowSettingTierLabel() -> UILabel {
    return self.showSettingTierLabel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
