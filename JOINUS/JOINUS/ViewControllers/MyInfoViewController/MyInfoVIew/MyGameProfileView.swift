//
//  MyGameProfileView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/14.
//

import UIKit

class MyGameProfileView: UIView {
  // MARK: View
  private let titleLabel = UILabel().then {
    $0.text = "내 게임"
    $0.font = UIFont.joinuns.font(size: 15)
    $0.textColor = .black
  }
  
  private let myGameImageView = UIImageView().then {
    $0.image = UIImage(named: "lol")
  }
  
  private let myGameLabel = UILabel().then {
    $0.text = "리그오브레전드"
    $0.font = UIFont.joinuns.font(size: 15)
    $0.textColor = .black
  }
  
  private let myTierLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 15)
    $0.textColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
  }
  
  // MARK: initialized
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.setupView()
  }
  
  private func setupView() {
    [titleLabel,
     myGameImageView,
     myGameLabel, myTierLabel].forEach { self.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.leading.equalTo(CommonLength.shared.width(17))
    }
    
    myGameImageView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(CommonLength.shared.height(18))
      $0.leading.equalTo(titleLabel)
      $0.width.height.equalTo(CommonLength.shared.width(34))
    }
    
    myGameLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(CommonLength.shared.height(15))
      $0.leading.equalTo(myGameImageView.snp.trailing).offset(CommonLength.shared.width(15))
    }
    
    myTierLabel.snp.makeConstraints {
      $0.top.equalTo(myGameLabel.snp.bottom).offset(5)
      $0.leading.equalTo(myGameLabel)
    }
  }
  
  func useMyGameImageView() -> UIImageView {
    return self.myGameImageView
  }
  
  func useMyGameLabel() -> UILabel {
    return self.myGameLabel
  }
  
  func useMyTierLabel() -> UILabel {
    return self.myTierLabel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
