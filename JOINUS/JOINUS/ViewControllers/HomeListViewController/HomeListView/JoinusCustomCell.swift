//
//  JoinusCustomCell.swift
//  JOINUS
//
//  Created by Demian on 2021/09/08.
//

import UIKit

class JoinusCustomCell: UITableViewCell {
  
  static let ID = "JoinusCustomCell"
  
  private let gameImageView = UIImageView().then {
    $0.image = UIImage(named: "lol")
  }
  
  private var startLabel = UILabel().then {
    $0.backgroundColor = UIColor.joinusColor.defaultPhotoGray
    $0.layer.cornerRadius = CommonLength.shared.height(20) / 2
    $0.clipsToBounds = true
    $0.font = UIFont.joinuns.font(size: 11)
    $0.textColor = .white
    $0.textAlignment = .center
  } 
  
  private let titleLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 15)
    $0.textColor = UIColor.joinusColor.customBlack
  }
  
  private let joinJangLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 13)
    $0.textColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
  }
  
  private let partitionView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
  }
  
  private let createdTimeLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 13)
    $0.textColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
  }
  
  private let personCountLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 17)
    $0.textColor = UIColor.joinusColor.customBlack
  }
  
  private let peopleImageView = UIImageView().then {
    $0.image = UIImage(named: "people")
    $0.contentMode = .scaleAspectFit
  }
  
  private let newLabel = UILabel().then {
    $0.text = "NEW"
    $0.font = UIFont.joinuns.font(size: 13)
    $0.textColor = UIColor.joinusColor.newPink
    $0.isHidden = true
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = .clear
    self.setupView()
  }
  
  private func setupView() {
    [gameImageView, startLabel,
     titleLabel, newLabel,
     joinJangLabel, partitionView, createdTimeLabel,
     personCountLabel, peopleImageView].forEach { self.addSubview($0) }
    
    gameImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(15))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(15))
      $0.width.height.equalTo(CommonLength.shared.width(32))
    }
    
    startLabel.snp.makeConstraints {
      $0.centerY.equalTo(gameImageView)
      $0.leading.equalTo(gameImageView.snp.trailing).offset(CommonLength.shared.width(10))
      $0.width.equalTo(CommonLength.shared.width(75))
      $0.height.equalTo(CommonLength.shared.height(20))
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(gameImageView.snp.bottom).offset(CommonLength.shared.height(10))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(15))
    }
    
    newLabel.snp.makeConstraints {
      $0.centerY.equalTo(titleLabel)
      $0.leading.equalTo(titleLabel.snp.trailing).offset(CommonLength.shared.width(5))
    }
    
    joinJangLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(CommonLength.shared.height(5))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(15))
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(15))
    }
    
    partitionView.snp.makeConstraints {
      $0.centerY.height.equalTo(joinJangLabel)
      $0.width.equalTo(1.3)
      $0.leading.equalTo(joinJangLabel.snp.trailing).offset(CommonLength.shared.width(7))
    }
    
    createdTimeLabel.snp.makeConstraints {
      $0.centerY.equalTo(joinJangLabel)
      $0.leading.equalTo(partitionView.snp.trailing).offset(CommonLength.shared.width(7))
    }
    
    peopleImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(15))
      $0.width.equalTo(CommonLength.shared.width(20))
      $0.height.equalTo(CommonLength.shared.height(12))
    }
    
    personCountLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalTo(peopleImageView.snp.leading).offset(-CommonLength.shared.width(7))
    }
  }
  
  func useStartLabel() -> UILabel {
    return self.startLabel
  }
  
  func useTitleLabel() -> UILabel {
    return self.titleLabel
  }
  
  func useNewLabel() -> UILabel {
    return self.newLabel
  }
  
  func useJoinJangLabel() -> UILabel {
    return self.joinJangLabel
  }
  
  func useCreatedTimeLabel() -> UILabel {
    return self.createdTimeLabel
  }
  
  func usePersonCountLabel() -> UILabel {
    return self.personCountLabel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
