//
//  CustomLeftBarButton.swift
//  JOINUS
//
//  Created by Demian on 2021/09/08.
//

import UIKit

class CustomLeftBarButton: UIButton {
  
  private let label = UILabel().then {
    $0.text = "리그오브레전드"
    $0.font = UIFont.joinuns.font(size: 17)
    $0.textColor = .black
  }
  
  private let image = UIImageView().then {
    $0.image = UIImage(named: "vector18")
    $0.contentMode = .scaleAspectFit
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.setupView()
  }
  
  private func setupView() {
    [label, image].forEach { self.addSubview($0) }
    
    label.snp.makeConstraints {
      $0.leading.equalToSuperview()
    }
    
    image.snp.makeConstraints {
      $0.top.equalTo(label.snp.centerY)
      $0.leading.equalTo(label.snp.trailing).offset(CommonLength.shared.width(5))
      $0.width.equalTo(CommonLength.shared.width(10))
      $0.height.equalTo(CommonLength.shared.height(5))
      $0.trailing.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
