//
//  GameButtonScrollView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/11.
//

import UIKit

class GameButtonScrollView: UIScrollView {
  // MARK: View
  private let lolButton = GameSelectButton(game: .lol)
  
  private let ovchButton = GameSelectButton(game: .overwatch)
  
  private let suddenButton = GameSelectButton(game: .suddenAttack)
  
  private let bagButton = GameSelectButton(game: .battleGround)
  
  private let mapleButton = GameSelectButton(game: .mapleStory)
  
  // MARK: initialized
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  private func setupView() {
    [lolButton, ovchButton, suddenButton, bagButton, mapleButton,].forEach { self.addSubview($0) }
    let buttonSize = CommonLength.shared.width(60)
    
    lolButton.snp.makeConstraints {
      $0.top.bottom.equalTo(self.safeAreaLayoutGuide)
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
      $0.width.height.equalTo(buttonSize)
    }
    
    ovchButton.snp.makeConstraints {
      $0.top.equalTo(lolButton)
      $0.leading.equalTo(lolButton.snp.trailing).offset(CommonLength.shared.width(20))
      $0.width.height.equalTo(buttonSize)
    }
    
    suddenButton.snp.makeConstraints {
      $0.top.equalTo(lolButton)
      $0.leading.equalTo(ovchButton.snp.trailing).offset(CommonLength.shared.width(20))
      $0.width.height.equalTo(buttonSize)
    }
    
    bagButton.snp.makeConstraints {
      $0.top.equalTo(lolButton)
      $0.leading.equalTo(suddenButton.snp.trailing).offset(CommonLength.shared.width(20))
      $0.width.height.equalTo(buttonSize)
    }
    
    mapleButton.snp.makeConstraints {
      $0.top.equalTo(lolButton)
      $0.leading.equalTo(bagButton.snp.trailing).offset(CommonLength.shared.width(20))
      $0.width.height.equalTo(buttonSize)
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(17))
    }
  }
  
  func useSelectGameButton(game: OnboardingModel.myGame) -> GameSelectButton {
    
    var button: GameSelectButton
    
    switch game {
      
      case .lol:
        button = self.lolButton
        
      case .suddenAttack:
        button = self.suddenButton
        
      case .overwatch:
        button = self.ovchButton
        
      case .battleGround:
        button = self.bagButton
        
      case .mapleStory:
        button = self.mapleButton
    }
    
    return button
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
