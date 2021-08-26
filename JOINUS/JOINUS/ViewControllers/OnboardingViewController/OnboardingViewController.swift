//
//  OnboardingViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/08/24.
//

import UIKit

class OnboardingViewController: UIViewController {

  // MARK: View
  private let titleLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.text = "성별과 나이를 입력해주세요"
    $0.font = UIFont.joinuns.font(size: 34)
  }
  
  private let maleButton = UIButton().then {
    $0.setTitle("남",
                for: .normal)
    $0.setTitleColor(UIColor.lightGray,
                     for: .normal)
    $0.backgroundColor = UIColor.joinusColor.genderDeselectedGray
    $0.titleLabel?.font = UIFont.joinuns.font(size: 13)
  }
  
  private let femaleButton = UIButton().then {
    $0.setTitle("여",
                for: .normal)
    $0.setTitleColor(UIColor.lightGray,
                     for: .normal)
    $0.backgroundColor = UIColor.joinusColor.genderDeselectedGray
    $0.titleLabel?.font = UIFont.joinuns.font(size: 13)
  }
  
  private let agePickerButton = AgePickerButton()
  
  private let nextButton = UIButton().then {
    $0.setTitle("확인",
                for: .normal)
    $0.setTitleColor(UIColor.lightGray,
                     for: .normal)
    $0.backgroundColor = UIColor.joinusColor.genderDeselectedGray
    $0.titleLabel?.font = UIFont.joinuns.font(size: 13)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
    self.setMaleButtonStatus()
    self.setFemaleButtonStatus()
  }
  
  func setupUI() {
    [titleLabel,
    maleButton, femaleButton,
    agePickerButton,
    nextButton].forEach { self.view.addSubview($0) }
    
//    titleLabel.snp.makeConstraints {
//      
//    }
  }
  
  func setMaleButtonStatus() {
    
    if self.maleButton.isSelected {
      
      self.maleButton.backgroundColor = UIColor.joinusColor.genderSelectedBlue
      self.maleButton.setTitleColor(UIColor.white,
                                    for: .selected)
      
    }
  }
  
  func setFemaleButtonStatus() {
    
    if self.femaleButton.isSelected {
      
      self.femaleButton.backgroundColor = UIColor.joinusColor.genderSelectedBlue
      self.femaleButton.setTitleColor(UIColor.white,
                                    for: .selected)
    }
  }
}
