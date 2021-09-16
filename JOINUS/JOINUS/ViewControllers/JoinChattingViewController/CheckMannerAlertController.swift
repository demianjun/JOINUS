//
//  CheckMannerAlertController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit

class CheckMannerAlertController: UIViewController {
  
  private let backgroundView = UIView().then {
    $0.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    $0.bounds = UIScreen.main.bounds
  }
  
  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
  }
  
  private let mannerScoreImageView = MannerScoreImageView()
  
  private let messageLabel = UILabel().then {
    $0.text = "팀원들의 평균 매너도가 표시 됩니다."
    $0.font = UIFont.joinuns.font(size: 16)
    $0.textColor = .black
  }
  
  private let okButton = JoinusButton(title: "확인",
                                      titleColor: .white,
                                      backGroundColor: UIColor.joinusColor.joinBlue)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .clear
    self.setupView()
  }
  
  private func setupView() {
    [backgroundView, containerView].forEach { self.view.addSubview($0) }
    
    backgroundView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    containerView.snp.makeConstraints {
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-20)
    }
    
    self.setupContainerView()
  }
  
  private func setupContainerView() {
    [mannerScoreImageView, messageLabel, okButton].forEach { self.containerView.addSubview($0) }
    
    mannerScoreImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(30))
      $0.height.equalTo(CommonLength.shared.height(45))
      $0.centerX.equalToSuperview()
    }
    
    messageLabel.snp.makeConstraints {
      $0.top.equalTo(mannerScoreImageView.snp.bottom).offset(CommonLength.shared.height(30))
      $0.centerX.equalToSuperview()
    }
    
    okButton.snp.makeConstraints {
      $0.top.equalTo(messageLabel.snp.bottom).offset(CommonLength.shared.height(20))
      $0.width.equalTo(CommonLength.shared.width(315))
      $0.height.equalTo(CommonLength.shared.height(50))
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(20))
    }
  }
  
  func useOkButton() -> UIButton {
    return self.okButton
  }
}
