//
//  MyInfoView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/14.
//

import UIKit

class MyProfileInfoView: UIView {
  // MARK: View
  private let profileImageView = UIImageView().then {
    $0.image = UIImage(named: "defaultProfile_60x60")
  }
  
  private let nickNameLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 14)
    $0.textColor = .black
  }
  
  private let editProfileButton = UIButton().then {
    $0.setTitle("프로필 수정",
                for: .normal)
    $0.setTitleColor(.white,
                     for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 14)
    $0.backgroundColor = UIColor.joinusColor.joinBlue
    $0.layer.cornerRadius = CommonLength.shared.height(32) / 2
  }
    
  // MARK: initialized
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.setupView()
  }
  
  private func setupView() {
    [profileImageView, nickNameLabel, editProfileButton].forEach { self.addSubview($0) }
    
    profileImageView.snp.makeConstraints {
      $0.top.leading.equalTo(CommonLength.shared.width(17))
      $0.bottom.equalTo(-CommonLength.shared.width(17))
      $0.width.height.equalTo(CommonLength.shared.width(60))
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.centerY.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(CommonLength.shared.width(10))
    }
    
    editProfileButton.snp.makeConstraints {
      $0.centerY.equalTo(profileImageView)
      $0.trailing.equalTo(-CommonLength.shared.width(17))
      $0.width.equalTo(CommonLength.shared.width(100))
      $0.height.equalTo(CommonLength.shared.height(32))
    }
  }
  
  func useNickNameLabel() -> UILabel {
    return self.nickNameLabel
  }
  
  func userEditProfileButton() -> UIButton {
    return self.editProfileButton
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
