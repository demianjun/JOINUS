//
//  MannerGuideView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/14.
//

import UIKit

class MannerGuideView: UIView {
  private let messageLabel_1 = UILabel().then {
    $0.text = "\u{2A} 매너도는 매칭 후 팀원평가를 통해 단계가 결정됩니다."
    $0.font = UIFont.joinuns.font(size: 13)
    $0.textColor = UIColor.joinusColor.defaultPhotoGray
  }
  
  private let messageLabel_2 = UILabel().then {
    $0.text = "\u{2A} 첫 매너도는 2단계에서 시작됩니다."
    $0.font = UIFont.joinuns.font(size: 13)
    $0.textColor = UIColor.joinusColor.defaultPhotoGray
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = #colorLiteral(red: 0.8712074757, green: 0.9313874841, blue: 0.9987366796, alpha: 1)
    self.setupView()
  }
  
  private func setupView() {
    [messageLabel_1, messageLabel_2].forEach { self.addSubview($0) }
    
    messageLabel_1.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(10))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(20))
    }
    
    messageLabel_2.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(10))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(20))
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
