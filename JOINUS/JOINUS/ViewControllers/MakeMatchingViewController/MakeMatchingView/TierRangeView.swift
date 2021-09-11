//
//  TierRangeView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/12.
//

import UIKit

class TierRangeView: UIView {
  // MARK: View
  private let titleLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 14)
    $0.textColor = .black
  }
  
  private let allTierButton = RangeTierButton().then {
    $0.useButtonTitleLabel().text = "모두 가능"
  }
  
  private let ironTierButton = RangeTierButton()
  
  private let bronzeTierButton = RangeTierButton()
  
  private let silverTierButton = RangeTierButton()
  
  private let goldTierButton = RangeTierButton()
  
  private let platinumTierButton = RangeTierButton()
  
  private let diaTierButton = RangeTierButton()
  
  private let masterTierButton = RangeTierButton()
  
  private let challengerTierButton = RangeTierButton()
  
  // MARK: initialized
  init(title: String) {
    super.init(frame: .zero)
    self.titleLabel.text = title
    self.backgroundColor = .white
    self.setButtonTitle(title: title)
    self.setupView()
  }
  
  private func setupView() {
    [titleLabel,
     allTierButton,
     ironTierButton,
     bronzeTierButton,
     silverTierButton,
     goldTierButton,
     platinumTierButton,
     diaTierButton,
     masterTierButton,
     challengerTierButton].forEach { self.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(20))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
    }
    
    allTierButton.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(35)
      $0.leading.equalTo(titleLabel)
    }
    
    ironTierButton.snp.makeConstraints {
      $0.top.equalTo(allTierButton.snp.bottom).offset(35)
      $0.leading.equalTo(titleLabel)
    }
    
    bronzeTierButton.snp.makeConstraints {
      $0.top.equalTo(ironTierButton.snp.bottom).offset(35)
      $0.leading.equalTo(titleLabel)
    }
    
    silverTierButton.snp.makeConstraints {
      $0.top.equalTo(bronzeTierButton.snp.bottom).offset(35)
      $0.leading.equalTo(titleLabel)
    }
    
    goldTierButton.snp.makeConstraints {
      $0.top.equalTo(silverTierButton.snp.bottom).offset(35)
      $0.leading.equalTo(titleLabel)
    }
    
    platinumTierButton.snp.makeConstraints {
      $0.top.equalTo(goldTierButton.snp.bottom).offset(35)
      $0.leading.equalTo(titleLabel)
    }
    
    masterTierButton.snp.makeConstraints {
      $0.top.equalTo(platinumTierButton.snp.bottom).offset(35)
      $0.leading.equalTo(titleLabel)
    }
    
    challengerTierButton.snp.makeConstraints {
      $0.top.equalTo(masterTierButton.snp.bottom).offset(35)
      $0.leading.equalTo(titleLabel)
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(17))
    }
  }
  
  private func setButtonTitle(title: String) {
    
    if title.contains("최소") {
    
      self.ironTierButton.useButtonTitleLabel().text = "아이언 이상"
      self.bronzeTierButton.useButtonTitleLabel().text = "브론즈 이상"
      self.silverTierButton.useButtonTitleLabel().text = "실버 이상"
      self.goldTierButton.useButtonTitleLabel().text = "골드 이상"
      self.platinumTierButton.useButtonTitleLabel().text = "플래티넘 이상"
      self.diaTierButton.useButtonTitleLabel().text = "다이아 이상"
      self.masterTierButton.useButtonTitleLabel().text = "마스터 이상"
      self.challengerTierButton.useButtonTitleLabel().text = "챌린저 이상"
    
    } else {
      
      self.ironTierButton.useButtonTitleLabel().text = "아이언 이하"
      self.bronzeTierButton.useButtonTitleLabel().text = "브론즈 이하"
      self.silverTierButton.useButtonTitleLabel().text = "실버 이하"
      self.goldTierButton.useButtonTitleLabel().text = "골드 이하"
      self.platinumTierButton.useButtonTitleLabel().text = "플래티넘 이하"
      self.diaTierButton.useButtonTitleLabel().text = "다이아 이하"
      self.masterTierButton.useButtonTitleLabel().text = "마스터 이하"
      self.challengerTierButton.useButtonTitleLabel().text = "챌린저 이하"
    }
  }
  
  func useAllTierSelectButton() -> RangeTierButton {
    return self.allTierButton
  }
  
  func useTierRangeSelectButton(tier: OnboardingModel.myTier) -> RangeTierButton {
    var button = RangeTierButton()
    switch tier {
      
      case .iron:
        button = self.ironTierButton
      case .bronze:
        button = self.bronzeTierButton
      case .silver:
        button = self.silverTierButton
      case .gold:
        button = self.goldTierButton
      case .platinum:
        button = self.platinumTierButton
      case .diamond:
        button = self.diaTierButton
      case .master:
        button = self.masterTierButton
      case .challenger:
        button = self.challengerTierButton
    }
    
    return button
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
