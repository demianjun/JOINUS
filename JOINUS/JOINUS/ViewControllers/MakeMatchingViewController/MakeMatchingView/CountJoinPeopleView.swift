//
//  CountJoinPeopleView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/11.
//

import UIKit

class CountJoinPeopleView: UIView {
  // MARK: View
  private let titleLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 17)
    $0.text = "참가자 수"
    $0.textColor = .black
  }
  
  private let countLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 17)
    $0.textAlignment = .center
    $0.textColor = .black
  }
  
  private let countUpButton = UIButton().then {
    $0.setImage(UIImage(named: "count_up"),
                for: .normal)
  }
  
  private let countDownButton = UIButton().then {
    $0.setImage(UIImage(named: "count_down"),
                for: .normal)
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
    [titleLabel, countDownButton, countLabel, countUpButton,
     partitionView].forEach { self.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(20))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(20))
    }
    
    countUpButton.snp.makeConstraints {
      $0.width.height.equalTo(CommonLength.shared.width(28))
      $0.centerY.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(17))
    }
    
    countLabel.snp.makeConstraints {
      $0.width.equalTo(CommonLength.shared.width(40))
      $0.centerY.equalTo(countUpButton)
      $0.trailing.equalTo(countUpButton.snp.leading)
    }
    
    countDownButton.snp.makeConstraints {
      $0.width.height.equalTo(CommonLength.shared.width(28))
      $0.centerY.equalTo(titleLabel)
      $0.trailing.equalTo(countLabel.snp.leading)
    }
    
    partitionView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.width.centerX.bottom.equalToSuperview()
    }
  }
  
  func useCountUpButton() -> UIButton {
    return self.countUpButton
  }
  
  func useCountDownButton() -> UIButton {
    return self.countDownButton
  }
  
  func useCountLabel() -> UILabel {
    return self.countLabel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
