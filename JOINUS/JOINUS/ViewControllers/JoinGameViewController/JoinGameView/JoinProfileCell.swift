//
//  JoinProfileView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/09.
//

import UIKit

class JoinProfileCell: UICollectionViewCell {
  static let ID = "JoinProfileView"
  
  // MARK: View
  private let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let userNameLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 13)
    $0.textAlignment = .center
    $0.textColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
    self.backgroundColor = .clear
  }
  
  private func setupView() {
    [profileImageView, userNameLabel].forEach { self.addSubview($0) }
    
    profileImageView.snp.makeConstraints {
      $0.top.centerX.equalToSuperview()
      $0.width.height.equalTo(CommonLength.shared.width(50))
    }
    
    userNameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(CommonLength.shared.height(5))
      $0.width.centerX.bottom.equalToSuperview()
    }
  }
  
  func useProfileImageView() -> UIImageView {
    return self.profileImageView
  }
  
  func useUserNameLabel() -> UILabel {
    return self.userNameLabel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
