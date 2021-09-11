//
//  SelectGameButton.swift
//  JOINUS
//
//  Created by Demian on 2021/08/31.
//

import UIKit

class GameSelectButton: UIButton {
  override var isSelected: Bool {
    didSet {
      self.greenView.isHidden = !self.isSelected
      self.selectImageView.isHidden = !self.isSelected
    }
  }
  
  // MARK: View
  private let gameImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
  }
  
  private let selectImageView = UIImageView().then {
    $0.image = UIImage(named: "vector5")
    $0.contentMode = .scaleAspectFit
    $0.isHidden = true
  }
  
  private let greenView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameSelectGreen
    $0.isHidden = true
  }
  
  init(game: OnboardingModel.myGame) {
    super.init(frame: .zero)
    self.layer.cornerRadius = CommonLength.shared.width(60) / 2
    self.clipsToBounds = true
    self.setButtonImage(game: game)
    self.setupView()
  }
  
  private func setupView() {
    [gameImageView, greenView, selectImageView].forEach { self.addSubview($0) }
    
    gameImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.height.equalTo(CommonLength.shared.width(60))
    }
    
    greenView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    selectImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.height.equalTo(CommonLength.shared.width(15))
    }
  }
  
  func setButtonImage(game: OnboardingModel.myGame) {
    self.gameImageView.image = UIImage(named: game.rawValue)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
