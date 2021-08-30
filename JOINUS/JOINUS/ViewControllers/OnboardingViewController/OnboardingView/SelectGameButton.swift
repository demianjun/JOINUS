//
//  SelectGameButton.swift
//  JOINUS
//
//  Created by Demian on 2021/08/31.
//

import UIKit

class GameSelectButton: UIButton {
  // MARK: View
  private let gameImageView = UIImageView().then {
    $0.isHidden = true
    $0.contentMode = .scaleAspectFill
  }
  
  init(title: String) {
    super.init(frame: .zero)
    self.setupView()
    self.setTitle(title,
                  for: .normal)
    self.setTitleColor(UIColor.joinusColor.joinBlue,
                     for: .normal)
    self.titleLabel?.font = UIFont.joinuns.font(size: 20)
    self.layer.cornerRadius = CommonLength.shared.width(60) / 2
    self.backgroundColor = UIColor.joinusColor.joinBlue.withAlphaComponent(0.5)
  }
  
  private func setupView() {
    [gameImageView].forEach { self.addSubview($0) }
    
    gameImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.height.equalTo(CommonLength.shared.width(50))
    }
  }
  
  func useGameImageView() -> UIImageView {
    return self.gameImageView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
