//
//  InputTitleView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/11.
//

import UIKit

class InputTitleView: UIView {
  // MARK: View
  private let inputTitleTextField = UITextField().then {
    let placeHoler = "방 제목을 입력해 주세요.",
        strNumber: NSString = placeHoler as NSString,
        range = (strNumber).range(of: placeHoler),
        font = UIFont.joinuns.font(size: 17),
        color = UIColor.joinusColor.gameIdTextFieldPlaceholderGray,
        attribute = NSMutableAttributedString.init(string: placeHoler)
    
    attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
    attribute.addAttribute(kCTFontAttributeName as NSAttributedString.Key, value: font, range: range)
    
    $0.attributedPlaceholder = attribute
    $0.placeholder = placeHoler
    $0.font = font
    $0.textColor = .black
    $0.backgroundColor = .white
    $0.addLeftPadding(width: CommonLength.shared.width(17))
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
    $0.keyboardAppearance = UIKeyboardAppearance.light
  }
  
  private let clearButton = UIButton().then {
    $0.setImage(UIImage(named: "group12"),
                for: .normal)
    $0.isHidden = true
  }
  
  private let partitionView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  private func setupView() {
    [inputTitleTextField, partitionView, clearButton].forEach { self.addSubview($0) }
    
    inputTitleTextField.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(20))
      $0.width.centerX.equalToSuperview()
//      $0.height.equalTo(CommonLength.shared.height(30))
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(20))
    }
    
    clearButton.snp.makeConstraints {
      $0.centerY.equalTo(inputTitleTextField)
      $0.width.height.equalTo(CommonLength.shared.width(23))
      $0.trailing.equalTo(inputTitleTextField).offset(-CommonLength.shared.width(15))
    }
    
    partitionView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.width.centerX.bottom.equalToSuperview()
    }
  }
  
  func useInputTitleTextField() -> UITextField {
    return self.inputTitleTextField
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
