//
//  StartDateSetView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/11.
//

import UIKit

class StartDateSetView: UIView {
  // MARK: View
  private let titleLabel = UILabel().then {
    $0.text = "게임시작 날짜"
    $0.textColor = .black
    $0.font = UIFont.joinuns.font(size: 17)
  }
  
  private let showSettingDateLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 17)
    $0.textColor = UIColor.joinusColor.defaultPhotoGray
  }
  
  private let changeDateButton = UIButton().then {
    $0.setTitle("변경",
                for: .normal)
    $0.setTitleColor(UIColor.joinusColor.joinBlue,
                     for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 17)
  }
  
  private let partitionView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
  }
  
  // MARK: Initialized
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  private func setupView() {
    [titleLabel,
     showSettingDateLabel, changeDateButton,
     partitionView].forEach { self.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(20))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
    }
    
    showSettingDateLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(CommonLength.shared.height(10))
      $0.leading.equalTo(titleLabel)
      $0.width.equalTo(CommonLength.shared.width(140))
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(20))
    }
    
    changeDateButton.snp.makeConstraints {
      $0.centerY.equalTo(showSettingDateLabel)
      $0.leading.equalTo(showSettingDateLabel.snp.trailing).offset(CommonLength.shared.width(10))
      $0.width.equalTo(CommonLength.shared.width(35))
      $0.height.equalTo(CommonLength.shared.height(25))
    }
    
    partitionView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.width.centerX.bottom.equalToSuperview()
    }
  }
  
  func useChangeDateButton() -> UIButton {
    return self.changeDateButton
  }
  
  func useShowSettingDateLabel() -> UILabel {
    return self.showSettingDateLabel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
