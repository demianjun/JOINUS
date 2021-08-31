//
//  LoginLogoView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/01.
//

import UIKit

class LoginLogoView: UIView {
  
  private let topLabel = UILabel().then {
    $0.text = "오늘 퇴근 후"
    $0.font = UIFont.joinuns.font(size: 34)
  }
  
  private let lolImageView = UIImageView().then {
    $0.image = UIImage(named: "socialLoginImage")
    $0.contentMode = .scaleAspectFit
  }
  
  private let bottomLabel = UILabel().then {
    $0.text = "같이 한판?"
    $0.font = UIFont.joinuns.font(size: 34)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.setupView()
  }
  
  private func setupView() {
    [topLabel, lolImageView, bottomLabel].forEach { self.addSubview($0) }
    
    topLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview()
    }
    
    lolImageView.snp.makeConstraints {
      $0.top.equalTo(topLabel.snp.bottom).offset(CommonLength.shared.height(5))
      $0.leading.equalToSuperview()
      $0.width.equalTo(CommonLength.shared.width(83))
      $0.height.equalTo(CommonLength.shared.height(47))
    }
    
    bottomLabel.snp.makeConstraints {
      $0.top.equalTo(lolImageView.snp.bottom).offset(CommonLength.shared.height(5))
      $0.leading.bottom.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

