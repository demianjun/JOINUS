//
//  NoCountImageView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/14.
//

import UIKit

class NoCountImageView: UIView {
  enum type {
    case joined, made, friend, black
  }
  
  private var type: type
  
  private let noCountImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: "alertImage2")
  }
  
  private let messageLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 15)
    $0.textColor = .black
  }
  
  init(type: type) {
    self.type = type
    super.init(frame: .zero)
    self.setupView()
    self.setMessage()
  }
  
  private func setupView() {
    [noCountImageView, messageLabel].forEach { self.addSubview($0) }
    
    noCountImageView.snp.makeConstraints {
      $0.width.height.equalTo(CommonLength.shared.width(120))
      $0.top.centerX.equalToSuperview()
    }
    
    messageLabel.snp.makeConstraints {
      $0.top.equalTo(noCountImageView.snp.bottom).offset(CommonLength.shared.height(17))
      $0.centerX.bottom.equalToSuperview()
    }
  }
  
  private func setMessage() {
    switch self.type {
      case .joined:
        
        self.messageLabel.text = "참여한 매칭이 없습니다."
        
      case .made:
        
        self.messageLabel.text = "내가 만든 매칭이 없습니다."
        
      case .friend:
        
        self.messageLabel.text = "추가한 친구가 없습니다."
        
      case .black:
        
        self.messageLabel.text = "추가한 블랙리스트가 없습니다."
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
