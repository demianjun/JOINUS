//
//  JoinusAlertController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/13.
//

import UIKit

class JoinusAlertController: UIViewController {
  enum position {
    case top, bottom
  }
  
  private let backgroundView = UIView().then {
    $0.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    $0.bounds = UIScreen.main.bounds
  }
  
  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
  }
  
  private let titleLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 15)
    $0.numberOfLines = 0
    $0.textAlignment = .center
    $0.textColor = .black
  }
  
  private let messageLabel = UILabel().then {
    $0.font = UIFont(name: "AppleSDGothicNeo-Regular",
                     size: UIScreen.main.bounds.width * 0.045)
    $0.numberOfLines = 0
    $0.textColor = .black
  }

  private let buttonsView = UIStackView().then {
    $0.backgroundColor = .white
    $0.axis = .horizontal
    $0.spacing = CommonLength.shared.width(15)
    $0.alignment = .center
    $0.distribution = .fillEqually
  }
  
  init(title position: position, title: String, explain message: String) {
    super.init(nibName: nil, bundle: nil)
    self.titleLabel.text = title
    self.messageLabel.text = message
    
    self.messageLabel.lineSpacing(spacing: 5,
                                  alignment: .center)
    
    self.setupUI()
    self.setTitleLabel(title: position)
  }
  
  convenience init(title position: position,
                   title text: String,
                   explain message: String,
                   add view: UIView? = nil) {
    
    self.init(title: position,
              title: text,
              explain: message)
    
    self.setAddView(newView: view ?? UIView(),
                    title: position)
  }
  
  private func setupUI() {
    self.modalPresentationStyle = .overFullScreen
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    self.view.addSubview(containerView)
    
    self.containerView.snp.makeConstraints {
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.height.greaterThanOrEqualToSuperview().multipliedBy(0.3)
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-20)
    }
  }
    
  private func setTitleLabel(title position: position) {
    [titleLabel, messageLabel,
     buttonsView].forEach { self.containerView.addSubview($0) }
    
    self.buttonsView.snp.makeConstraints {
      $0.height.equalTo(CommonLength.shared.width(50))
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(15))
    }
    
    switch position {
    case .top:
      titleLabel.snp.makeConstraints {
        if messageLabel.text == "" {
          $0.top.equalToSuperview().offset(CommonLength.shared.height(45))
          
        } else {
          $0.top.equalToSuperview().offset(CommonLength.shared.height(33))
          
        }
        $0.centerX.width.equalToSuperview()
      }
      
      if messageLabel.text!.contains("6단계") || messageLabel.text == "" {
        messageLabel.snp.makeConstraints {
          $0.top.equalTo(titleLabel.snp.bottom).offset(self.view.frame.height * 0.02)
          $0.centerX.width.equalToSuperview()
        }
        
      } else {
        messageLabel.snp.makeConstraints {
          $0.top.equalTo(titleLabel.snp.bottom).offset(self.view.frame.height * 0.02)
          $0.centerX.equalToSuperview()
          $0.width.equalToSuperview().multipliedBy(0.95)
          $0.bottom.lessThanOrEqualTo(buttonsView.snp.top).offset(-CommonLength.shared.width(10))
        }
        
      }
      
    case .bottom:
      titleLabel.snp.makeConstraints {
        $0.bottom.equalTo(messageLabel.snp.top).offset(-self.view.frame.height * 0.02)
        $0.centerX.width.equalToSuperview()
      }
      messageLabel.snp.makeConstraints {
        $0.top.equalTo(titleLabel.snp.bottom).offset(self.view.frame.height * 0.02)
        $0.bottom.equalTo(buttonsView.snp.top).offset(-self.view.frame.height * 0.04)
        $0.centerX.width.equalToSuperview()
      }
    }
  }
  
  private func setAddView(newView: UIView, title position: position) {
    self.containerView.addSubview(newView)
    
    switch position {
    case .top:
      newView.snp.makeConstraints {
        if self.messageLabel.text == "" {
          $0.top.equalTo(titleLabel.snp.bottom).offset(CommonLength.shared.height(10))
          
        } else {
          $0.top.equalTo(messageLabel.snp.bottom).offset(CommonLength.shared.height(10))
          
        }

        $0.bottom.lessThanOrEqualTo(buttonsView.snp.top).offset(-CommonLength.shared.height(10))
        $0.centerX.equalToSuperview()
      }
      
    case .bottom:
      newView.snp.makeConstraints {
        $0.top.equalToSuperview().offset(CommonLength.shared.height(20))
        $0.bottom.equalTo(titleLabel.snp.top).offset(-CommonLength.shared.height(15))
        $0.centerX.equalToSuperview()
      }
    }
  }
  
  func addAction(_ action: UIButton) {
    self.buttonsView.addArrangedSubview(action)
    
    action.snp.makeConstraints {
      $0.height.equalToSuperview()
    }
  }
    
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
