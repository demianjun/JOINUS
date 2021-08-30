//
//  OnboardingViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/08/24.
//

import UIKit
import RxSwift

class OnboardingViewController: UIViewController {
  private let bag = DisposeBag()
  
  private let changeWindow = ChangeWindow()
  
  // MARK: View
  private let titleLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.text = "성별과 나이를\n입력해주세요"
    $0.textColor = .black
    $0.font = UIFont.joinuns.font(size: 34)
    $0.lineSpacing(spacing: 5,
                   alignment: .left)
  }
  
  private let maleButton = UIButton().then {
    $0.setTitle("남",
                for: .normal)
    $0.setTitleColor(UIColor.lightGray,
                     for: .normal)
    $0.setTitleColor(UIColor.white,
                     for: .selected)
    $0.backgroundColor = UIColor.joinusColor.genderDeselectedGray
    $0.titleLabel?.font = UIFont.joinuns.font(size: 13)
    $0.layer.cornerRadius = CommonLength.shared.height(35) / 2
  }
  
  private let femaleButton = UIButton().then {
    $0.setTitle("여",
                for: .normal)
    $0.setTitleColor(UIColor.lightGray,
                     for: .normal)
    $0.setTitleColor(UIColor.white,
                     for: .selected)
    $0.backgroundColor = UIColor.joinusColor.genderDeselectedGray
    $0.titleLabel?.font = UIFont.joinuns.font(size: 13)
    $0.layer.cornerRadius = CommonLength.shared.height(35) / 2
  }
  
  private let agePickerButton = AgePickerButton()
  
  private let nextButton = UIButton().then {
    $0.setTitle("확인",
                for: .normal)
    $0.setTitleColor(UIColor.lightGray,
                     for: .normal)
    $0.backgroundColor = UIColor.joinusColor.genderDeselectedGray
    $0.titleLabel?.font = UIFont.joinuns.font(size: 13)
    $0.layer.cornerRadius = 2
  }
  
  private let leftButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                               style: .plain,
                                               target: nil,
                                               action: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.setNavigationBar()
    self.setupUI()
    self.popViewController()
    self.didTapSelectGenderButton()
  }
  
  func setupUI() {
    [titleLabel,
     maleButton, femaleButton,
     agePickerButton,
     nextButton].forEach { self.view.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(CommonLength.shared.height(40))
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.9)
    }
    
    maleButton.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(CommonLength.shared.height(25))
      $0.leading.equalTo(titleLabel)
      $0.width.equalTo(CommonLength.shared.width(100))
      $0.height.equalTo(CommonLength.shared.height(35))
    }
    
    femaleButton.snp.makeConstraints {
      $0.top.equalTo(maleButton)
      $0.leading.equalTo(maleButton.snp.trailing).offset(CommonLength.shared.width(25))
      $0.width.equalTo(CommonLength.shared.width(100))
      $0.height.equalTo(CommonLength.shared.height(35))
    }
    
    agePickerButton.snp.makeConstraints {
      $0.top.equalTo(maleButton.snp.bottom).offset(CommonLength.shared.height(25))
      $0.leading.equalTo(titleLabel)
      $0.width.equalTo(CommonLength.shared.width(225))
      $0.height.equalTo(CommonLength.shared.height(50))
    }
    
    nextButton.snp.makeConstraints {
      $0.top.equalTo(agePickerButton.snp.bottom).offset(CommonLength.shared.height(60))
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.height.equalTo(CommonLength.shared.height(50))
    }
  }
  
  func setMaleButtonStatus() {
    
    if self.maleButton.isSelected {
      
      self.maleButton.backgroundColor = UIColor.joinusColor.genderSelectedBlue
      
    } else {
      
      self.maleButton.backgroundColor = UIColor.joinusColor.genderDeselectedGray
    }
  }
  
  func setFemaleButtonStatus() {
    
    if self.femaleButton.isSelected {
      
      self.femaleButton.backgroundColor = UIColor.joinusColor.genderSelectedBlue
      
    } else {
      
      self.femaleButton .backgroundColor = UIColor.joinusColor.genderDeselectedGray
    }
  }
  
  private func setNavigationBar() {
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationController?.navigationBar.topItem?.title = ""
    self.navigationItem.leftBarButtonItem = self.leftButtonItem
  }
  
  private func popViewController() {
    self.leftButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        let loginVC = LoginViewController()
        
        self.changeWindow
          .change(change: loginVC)
        
      }).disposed(by: self.bag)
  }
  
  private func didTapSelectGenderButton() {
    
    self.maleButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
      
        self.maleButton.isSelected = true
        self.femaleButton.isSelected = false
        
        self.setMaleButtonStatus()
        self.setFemaleButtonStatus()
        
      }).disposed(by: self.bag)
    
    self.femaleButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
      
        self.maleButton.isSelected = false
        self.femaleButton.isSelected = true
        
        self.setMaleButtonStatus()
        self.setFemaleButtonStatus()
        
      }).disposed(by: self.bag)
  }
}
