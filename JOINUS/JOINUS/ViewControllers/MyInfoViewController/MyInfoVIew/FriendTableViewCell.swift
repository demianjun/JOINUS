//
//  FriendTableViewCell.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
  static let ID = "FriendTableViewCell"
  
  // MARK: View
  private let profileImageView = UIImageView().then {
    $0.image = UIImage(named: "defaultProfile_60x60")
  }
  
  private let nickNameLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 14)
    $0.textColor = .black
  }
  
  private let administrateButton = UIButton().then {
    $0.setTitle("관리",
                for: .normal)
    $0.setTitleColor(UIColor.joinusColor.joinBlue,
                     for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 16)
  }
  
  // MARK: initialized
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = .white
    self.setupView()
  }
  
  private func setupView() {
    [profileImageView, nickNameLabel, administrateButton].forEach { self.addSubview($0) }
    
    profileImageView.snp.makeConstraints {
      $0.top.leading.equalTo(CommonLength.shared.width(17))
      $0.bottom.equalTo(-CommonLength.shared.width(17))
      $0.width.height.equalTo(CommonLength.shared.width(60))
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.centerY.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(CommonLength.shared.width(10))
    }
    
    administrateButton.snp.makeConstraints {
      $0.width.equalTo(CommonLength.shared.width(30))
      $0.height.equalTo(CommonLength.shared.height(25))
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(17))
    }
  }
  
  func useProfileImageView() -> UIImageView {
    return self.profileImageView
  }
  
  func useNickNameLabel() -> UILabel {
    return self.nickNameLabel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
