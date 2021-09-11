//
//  SelectGameView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/11.
//

import UIKit

class SelectGameView: UIView {
  // MARK: View
  private let titleLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 17)
    $0.text = "게임선택"
    $0.textColor = .black
  }
  
  private let gameButtonScrollView = GameButtonScrollView().then {
    $0.contentSize = CGSize(width: CommonLength.shared.width(450),
                            height: 0)
  }
  
  private let partitionView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
  }
  
  // MARK: initialized
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  private func setupView() {
    [titleLabel,
     gameButtonScrollView,
     partitionView].forEach { self.addSubview($0) }
    
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(20))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
    }
    
    gameButtonScrollView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(CommonLength.shared.height(10))
//      $0.leading.width.equalToSuperview()
      $0.leading.width.equalTo(self.safeAreaLayoutGuide)
      $0.height.equalTo(CommonLength.shared.height(55))
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(20))
    }
    
    partitionView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.width.equalToSuperview()
      $0.centerX.bottom.equalToSuperview()
    }
  }
  
//  func useSelectGameButton(game: OnboardingModel.myGame) -> GameSelectButton {
//    var button = GameSelectButton(game: .lol)
//    switch game {
//
//      case .lol:
//        button = self.gameScrollView.useSelectGameButton(game: .lol)
//      case .suddenAttack:
//        button = self.gameScrollView.useSelectGameButton(game: .suddenAttack)
//      case .overwatch:
//        button = self.gameScrollView.useSelectGameButton(game: .overwatch)
//      case .battleGround:
//        button = self.gameScrollView.useSelectGameButton(game: .battleGround)
//      case .mapleStory:
//        button = self.gameScrollView.useSelectGameButton(game: .mapleStory)
//    }
//
//    return button
//  }
  
  func useGameScrollView() -> GameButtonScrollView {
    return self.gameButtonScrollView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
