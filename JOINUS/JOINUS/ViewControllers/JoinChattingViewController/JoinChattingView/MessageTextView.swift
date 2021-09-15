//
//  messageTextView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit

class MessageTextView: UIView {
  private let partition = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
  }
  
  private let inputTextView = UITextView().then {
    $0.isScrollEnabled = false
    $0.textAlignment = NSTextAlignment.left
    $0.font = UIFont.joinuns.font(size: 15)
    $0.textColor = .black
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 2
    $0.contentInset = UIEdgeInsets(top: 0, left: CommonLength.shared.width(13), bottom: 0, right: 0)
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
    $0.keyboardAppearance = UIKeyboardAppearance.light
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray.cgColor
    $0.layer.cornerRadius = CommonLength.shared.height(28) / 2
  }
  
  private let sendButton = UIButton().then {
    $0.setImage(UIImage(systemName: "arrow.right.circle.fill"),
                for: .normal)
    $0.tintColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
    $0.adjustsImageWhenHighlighted = false
    $0.transform = .init(scaleX: 2.0, y: 2.0)
  }
  
  private let placeHolderLabel = UILabel().then {
    $0.text = "메세지를 입력하세요."
    $0.font = UIFont.joinuns.font(size: 15)
    $0.textColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
  }
  
  private let backGroundView = UIView().then {
    $0.backgroundColor = .white
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  private func setupView() {
    [backGroundView, partition].forEach { self.addSubview($0) }
    [inputTextView, placeHolderLabel, sendButton].forEach { self.backGroundView.addSubview($0) }
    
    backGroundView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    inputTextView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.height.equalTo(CommonLength.shared.height(28))
    }
    
    placeHolderLabel.snp.makeConstraints {
      $0.centerY.equalTo(inputTextView)
      $0.leading.equalTo(inputTextView).offset(CommonLength.shared.width(17))
    }
    
    sendButton.snp.makeConstraints {
      $0.trailing.equalTo(inputTextView).offset(-CommonLength.shared.width(4))
      $0.centerY.equalTo(inputTextView)
      $0.width.height.equalTo(CommonLength.shared.width(27))
    }
    
    partition.snp.makeConstraints {
      $0.top.equalTo(backGroundView)
      $0.width.centerX.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
  
  func useInputTextView() -> UITextView {
    return self.inputTextView
  }
  
  func usePlaceHolderLabel() -> UILabel {
    return self.placeHolderLabel
  }

  func useSendButton() -> UIButton {
    return self.sendButton
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
