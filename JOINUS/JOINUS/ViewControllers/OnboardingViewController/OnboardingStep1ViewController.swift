//
//  OnboardingViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/08/24.
//

import UIKit
import RxSwift

class OnboardingStep1ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  
  private let bag = DisposeBag()
  
  private let changeWindow = ChangeWindow(),
              setNext = NextButtonStatus()
  
  // MARK: Model
  private let onboardingModel = OnboardingModel.shared,
              myInfoModel = MyInfoModel.shared
  
  // MARK: ViewModel
  public let onboardingViewModel = OnboardingViewModel()
  
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
  
  private let agePickerTextField = AgePickerTextField()
  
  private let pickerView = UIPickerView().then {
    $0.backgroundColor = .white
    $0.setValue(UIColor.black,
                forKey: "textColor")
    $0.frame = CGRect(x: 0, y: 0,
                      width: CommonLength.shared.width(375),
                      height: CommonLength.shared.width(300))
  }
  
  private var nextButton = UIButton().then {
    $0.setTitle("확인",
                for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 15)
    $0.layer.cornerRadius = 2
  }
  
  private let leftButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                               style: .plain,
                                               target: nil,
                                               action: nil)
  
  private let toolBarView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let partitionView = UIView().then {
    $0.backgroundColor = CommonColor.shared.customColor(r: 17, g: 17, b: 17, alpha: 0.6)//gray
  }
  
  private let customOkBarButtonItem = UIButton().then {
    $0.setTitle("확인",
                for: .normal)
    $0.setTitleColor(UIColor.joinusColor.joinBlue,
                     for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 17)
  }
  
  private let customCancelBarButtonItem = UIButton().then {
    $0.setTitle("닫기",
                for: .normal)
    $0.setTitleColor(UIColor.black,
                     for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 17)
  }
  
  override func loadView() {
    super.loadView()
    self.onboardingViewModel
      .bindCheckNextStep()
    
    self.onboardingViewModel
      .enableStep2outputSubject
      .bind(onNext: { isEnable in
        self.nextButton.isEnabled = isEnable
        self.setNext.buttonStatus(nextButton: self.nextButton)
      }).disposed(by: bag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.setNavigationBar()
    self.setupUI()
    self.popViewController()
    self.didTapSelectGenderButton()
    self.agePickerTextField.inputView = self.pickerView
    self.agePickerTextField.inputView?.tintColor = .white
    self.pickerView.delegate = self
    self.pickerView.dataSource = self
    self.inputBarButton()
    self.tapDoneButton()
    self.didTapNextButton()
  }
  
  private func setupUI() {
    [titleLabel,
     maleButton, femaleButton,
     agePickerTextField,
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
    
    agePickerTextField.snp.makeConstraints {
      $0.top.equalTo(maleButton.snp.bottom).offset(CommonLength.shared.height(25))
      $0.leading.equalTo(titleLabel)
      $0.width.equalTo(CommonLength.shared.width(225))
      $0.height.equalTo(CommonLength.shared.height(50))
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(200))
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.height.equalTo(CommonLength.shared.height(50))
    }
  }
  
  private func setMaleButtonStatus() {
    
    if self.maleButton.isSelected {
      
      self.maleButton.backgroundColor = UIColor.joinusColor.genderSelectedBlue
      
    } else {
      
      self.maleButton.backgroundColor = UIColor.joinusColor.genderDeselectedGray
    }
  }
  
  private func setFemaleButtonStatus() {
    
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
  
  private func inputBarButton() {
    
    self.toolBarView.addSubview(customOkBarButtonItem)
    self.toolBarView.addSubview(customCancelBarButtonItem)
    self.toolBarView.addSubview(partitionView)
    
    self.toolBarView.frame = CGRect(x: 0, y:0,
                                    width: CommonLength.shared.width(375),
                                    height: CommonLength.shared.height(35))
    
    customCancelBarButtonItem.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(15))
      $0.width.equalTo(CommonLength.shared.width(50))
      $0.height.equalTo(CommonLength.shared.height(30))
    }
    
    customOkBarButtonItem.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(15))
      $0.width.equalTo(CommonLength.shared.width(50))
      $0.height.equalTo(CommonLength.shared.height(30))
    }
    
    partitionView.snp.makeConstraints {
      $0.bottom.equalTo(self.toolBarView.snp.top)
      $0.height.equalTo(1)
      $0.width.centerX.equalToSuperview()
    }
    
    self.agePickerTextField.inputAccessoryView = self.toolBarView
  }
  
  private func tapDoneButton() {
    
    customCancelBarButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.view.endEditing(true)
        
      }).disposed(by: self.bag)
    
    customOkBarButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.agePickerTextField
          .useButtonLabel()
          .text = String(self.myInfoModel.myAge).appending("세")
        
        self.view.endEditing(true)
        
        self.onboardingViewModel
          .selectAgeInputSubject
          .onNext(self.myInfoModel.myAge)
        
      }).disposed(by: self.bag)
  }
  
  private func popViewController() {
    self.leftButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        let loginVC = LoginViewController()
        
        self.maleButton.isSelected = false
        self.femaleButton.isSelected = false
        
        self.changeWindow
          .change(change: loginVC)
        
      }).disposed(by: self.bag)
  }
  
  private func didTapSelectGenderButton() {
    enum gender {
      case male, female
    }
    
    Observable
      .of(self.maleButton.rx.tap.map { gender.male },
          self.femaleButton.rx.tap.map { gender.female })
      .merge()
      .asObservable()
      .bind { selectGender in
        
        var maleSelect = Bool(),
            myGender = Int()
        
        switch selectGender {
          
          case .male:
            
            maleSelect = true
            myGender = 0
            
          case .female:
            
            maleSelect = false
            myGender = 1
        }
        
        self.maleButton.isSelected = maleSelect
        self.femaleButton.isSelected = !maleSelect
        
        self.setMaleButtonStatus()
        self.setFemaleButtonStatus()
        
        self.myInfoModel.myGender = myGender
        self.onboardingViewModel
          .selectGenderInputSubject
          .onNext(myGender)
        
      }.disposed(by: self.bag)
  }
  
  private func didTapNextButton() {
    
    let onboardingStept2VC = OnboardingStep2ViewController()
    
    CommonAction.shared.touchActionEffect(self.nextButton) {
      
      if self.nextButton.isEnabled {
        
        self.navigationController?
          .pushViewController(onboardingStept2VC,
                              animated: true)
      }
    }
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.onboardingModel.ages.count
  }
  
  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return CommonLength.shared.height(42)
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    
    let label = (view as? UILabel) ?? UILabel()
    
    
    label.font = UIFont.joinuns.font(size: 15)
    label.textColor = .black
    label.textAlignment = .center
    label.text = self.onboardingModel.ages[row]
    
    return label
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let selectAge = row + 20
    
    self.myInfoModel.myAge = selectAge
  }
}
