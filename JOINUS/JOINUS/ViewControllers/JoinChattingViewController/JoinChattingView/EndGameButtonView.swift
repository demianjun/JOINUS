//
//  EndGameButtonView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/17.
//

import UIKit

class EndGameButtonView: UIView {
  private let partition = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
  }
  
  private let endGuideLabel = UILabel().then {
    $0.text = "\u{2A} 게임이 완료되면 버튼을 눌러 주세요."
    $0.font = UIFont.joinuns.font(size: 11)
    $0.textColor = UIColor.joinusColor.defaultPhotoGray
  }
  
  private let endGameButton = UIButton().then {
    $0.setTitle("게임완료",
                for: .normal)
    $0.setTitleColor(.white,
                     for: .normal)
    $0.backgroundColor = .joinusColor.joinBlue
    $0.layer.cornerRadius = CommonLength.shared.height(35) / 2
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  private func setupView() {
    [partition, endGuideLabel, endGameButton].forEach { self.addSubview($0) }
    
    endGameButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(15))
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(17))
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(15))
      $0.width.equalTo(CommonLength.shared.width(100))
      $0.height.equalTo(CommonLength.shared.height(35))
    }
    
    endGuideLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
    }
    
    partition.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
  
  func useEndButton() -> UIButton {
    return self.endGameButton
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
