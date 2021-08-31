//
//  GoogleLoginButton.swift
//  JOINUS
//
//  Created by Demian on 2021/09/01.
//

import UIKit

class GoogleLoginButton: UIButton {
  
  // MARK: View
  private let logoImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.image = UIImage(named: "logoGoogle")
  }
  
  internal let buttonLabel = UILabel().then {
    $0.text = "구글로 시작하기"
    $0.textColor = .black
    $0.font = UIFont.joinuns.font(size: 15)
  }
  
  // MARK: Initialized
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.layer.cornerRadius = 2
    self.setupView()
  }
  
  private func setupView() {
    [logoImageView, buttonLabel].forEach { self.addSubview($0) }
    
    buttonLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    logoImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(20))
      $0.width.height.equalTo(CommonLength.shared.width(29))
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

