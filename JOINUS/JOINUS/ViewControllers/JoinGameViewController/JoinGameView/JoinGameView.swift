//
//  JoinGameView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/09.
//

import UIKit

class JoinGameView: UIView {
  
  // MARK: View
  private let gameImageView = UIImageView().then {
    $0.image = UIImage(named: "lol")
  }
  
  private let titleLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 17)
    $0.textColor = .black
  }
  
  private let partitionView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
  }
  
  private let joinPeople = JoinGameListLabel(title: "참가인원")
  
  private let startGameDate = JoinGameListLabel(title: "시작날짜")
  
  private let tierOfStandard = JoinGameListLabel(title: "티어")
  
  private let voiceChatCheck = JoinGameListLabel(title: "음성채팅 유무")
  
  private let joinPeopleProfileCollectionView = JoinPeopleProfileCollectionView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.setupView()
  }
  
  private func setupView() {
    [gameImageView, titleLabel,
     partitionView,
     joinPeople,
     startGameDate,
     tierOfStandard,
     voiceChatCheck,
     joinPeopleProfileCollectionView].forEach { self.addSubview($0) }
    
    gameImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(22))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
      $0.width.height.equalTo(CommonLength.shared.width(30))
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerY.equalTo(gameImageView)
      $0.leading.equalTo(gameImageView.snp.trailing).offset(CommonLength.shared.width(12))
    }
    
    partitionView.snp.makeConstraints {
      $0.top.equalTo(gameImageView.snp.bottom).offset(CommonLength.shared.height(15))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(17))
      $0.height.equalTo(1.2)
    }
    
    joinPeople.snp.makeConstraints {
      $0.top.equalTo(partitionView.snp.bottom).offset(CommonLength.shared.height(15))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
    }
    
    startGameDate.snp.makeConstraints {
      $0.top.equalTo(joinPeople.snp.bottom).offset(CommonLength.shared.height(12))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
    }
    
    tierOfStandard.snp.makeConstraints {
      $0.top.equalTo(startGameDate.snp.bottom).offset(CommonLength.shared.height(12))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
    }
    
    voiceChatCheck.snp.makeConstraints {
      $0.top.equalTo(tierOfStandard.snp.bottom).offset(CommonLength.shared.height(12))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
    }
    
    joinPeopleProfileCollectionView.snp.makeConstraints {
      $0.top.equalTo(voiceChatCheck.snp.bottom).offset(CommonLength.shared.height(22))
      $0.height.equalTo(CommonLength.shared.height(70))
      $0.width.equalTo(CommonLength.shared.width(170))
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(22))
    }
    
  print("collection view load")
  }
  
  func useTitleLabel() -> UILabel {
    return self.titleLabel
  }
  
  func useJoinPeople() -> JoinGameListLabel {
    return self.joinPeople
  }
  
  func useStartGameDate() -> JoinGameListLabel {
    return self.startGameDate
  }
  
  func useTierOfStandard() -> JoinGameListLabel {
    return self.tierOfStandard
  }
  
  func useVoiceChatCheck() -> JoinGameListLabel {
    return self.voiceChatCheck
  }
  
  func useJoinPeopleProfileCollectionView() -> JoinPeopleProfileCollectionView {
    return self.joinPeopleProfileCollectionView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
