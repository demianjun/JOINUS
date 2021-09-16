//
//  File.swift
//  JOINUS
//
//  Created by Demian on 2021/09/16.
//

import UIKit

class MessageView: UIView {
  // MARK: View
  private let userNameLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 13)
    $0.textColor = .black
  }
  
  private let sendTimeLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 13)
    $0.textColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
  }
  
  private let messgaeLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.font = UIFont.joinuns.font(size: 17)
    $0.textColor = .black
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  private func setupView() {
    [userNameLabel, sendTimeLabel, messgaeLabel].forEach { self.addSubview($0) }
    
    userNameLabel.snp.makeConstraints {
      $0.top.leading.equalTo(CommonLength.shared.width(13))
    }
    
    sendTimeLabel.snp.makeConstraints {
      $0.top.equalTo(userNameLabel)
      $0.leading.greaterThanOrEqualTo(userNameLabel.snp.trailing).offset(CommonLength.shared.width(13))
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.height(13))
    }
    
    messgaeLabel.snp.makeConstraints {
      $0.top.equalTo(userNameLabel.snp.bottom).offset(CommonLength.shared.height(5))
      $0.leading.equalTo(userNameLabel)
      $0.trailing.greaterThanOrEqualTo(sendTimeLabel)
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(13))
    }
  }
  
  func useUserNameLabel() -> UILabel {
    return self.userNameLabel
  }
  
  func useSendTimeLabel() -> UILabel {
    return self.sendTimeLabel
  }
  
  func useMessageLabel() -> UILabel {
    return self.messgaeLabel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
