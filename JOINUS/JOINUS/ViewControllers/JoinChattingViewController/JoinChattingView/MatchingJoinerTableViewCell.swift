//
//  MatchingJoinerTableViewCell.swift
//  JOINUS
//
//  Created by Demian on 2021/09/17.
//

import UIKit

class MatchingJoinerTableViewCell: UITableViewCell {
  static let ID = "MatchingJoinerTableViewCell"
  
  // MARK: View
  private let profileImageView = UIImageView()
  
  private let userNameLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 12)
    $0.textColor = .black
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = .clear
    self.setupView()
  }
  
  private func setupView() {
    [profileImageView, userNameLabel].forEach { self.addSubview($0) }
    
    profileImageView.snp.makeConstraints {
      $0.width.height.equalTo(CommonLength.shared.width(60))
      $0.top.equalToSuperview().offset(CommonLength.shared.height(10))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(15))
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(10))
    }
    
    userNameLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(profileImageView.snp.trailing).offset(CommonLength.shared.width(15))
    }
  }
  
  func useUserNameLabel() -> UILabel {
    return self.userNameLabel
  }
  
  func useProfileImageView() -> UIImageView {
    return self.profileImageView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
