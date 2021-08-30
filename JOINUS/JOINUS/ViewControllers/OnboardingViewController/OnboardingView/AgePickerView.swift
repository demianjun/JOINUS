//
//  AgePickerView.swift
//  JOINUS
//
//  Created by Demian on 2021/08/27.
//

import UIKit

class AgePickerTextField: UITextField {//UIButton {
  
  // MARK: View
  private let buttonLabel = UILabel().then {
    $0.text = "나이를 선택해 주세요."
    $0.font = UIFont.joinuns.font(size: 15)
    $0.textColor = UIColor.joinusColor.genderDeselectedGray
    $0.textAlignment = .left
  }
  
  private let accessoryImageView = UIImageView().then {
    $0.image = UIImage(systemName: "chevron.down")
    $0.tintColor = UIColor.joinusColor.joinBlue
    $0.contentMode = .scaleAspectFill
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.layer.borderWidth = 2
    self.layer.borderColor = UIColor.joinusColor.genderDeselectedGray.cgColor
    self.layer.cornerRadius = 2
    self.setupView()
  }
  
  private func setupView() {
    [buttonLabel, accessoryImageView].forEach { self.addSubview($0) }
    
    buttonLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(15))
    }
    
    accessoryImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(15))
      $0.width.equalTo(CommonLength.shared.width(15))
      $0.height.equalTo(CommonLength.shared.height(13))
    }
  }
  
  func useButtonLabel() -> UILabel {
    return self.buttonLabel
  }
  
  func useAccessoryImageView() -> UIImageView {
    return self.accessoryImageView
  }
  
//  func usePickerView() -> UIPickerView {
//    return self.pickerView
//  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
