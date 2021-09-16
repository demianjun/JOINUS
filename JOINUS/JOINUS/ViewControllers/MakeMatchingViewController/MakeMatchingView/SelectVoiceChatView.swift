//
//  SelectVoiceChatView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/11.
//

import UIKit

class SelectVoiceChatView: UIView {
  // MARK: View
  private let titleLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 17)
    $0.text = "음성채팅 유무"
    $0.textColor = .black
  }
  
  private let possibilityButton = ToggleButton(set: "가능")
  
  private let impossibilityButton = ToggleButton(set: "불가능")
  
  private let partitionView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
  }
  
  // MARK: initialized
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  private func setupView() {
    [titleLabel, possibilityButton, impossibilityButton, partitionView].forEach { self.addSubview($0) }
    let buttonWidth = CommonLength.shared.width(100),
        buttonHeight = CommonLength.shared.height(30)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(20))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
    }
    
    possibilityButton.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(CommonLength.shared.height(10))
      $0.leading.equalTo(titleLabel)
      $0.width.equalTo(buttonWidth)
      $0.height.equalTo(buttonHeight)
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(20))
    }
    
    impossibilityButton.snp.makeConstraints {
      $0.top.equalTo(possibilityButton)
      $0.leading.equalTo(possibilityButton.snp.trailing).offset(CommonLength.shared.width(25))
      $0.width.equalTo(buttonWidth)
      $0.height.equalTo(buttonHeight)
    }
    
    partitionView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.width.centerX.bottom.equalToSuperview()
    }
  }
  
  func usePossibilityButton() -> UIButton {
    return self.possibilityButton
  }
  
  func useImpossibilityButton() -> UIButton {
    return self.impossibilityButton
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
