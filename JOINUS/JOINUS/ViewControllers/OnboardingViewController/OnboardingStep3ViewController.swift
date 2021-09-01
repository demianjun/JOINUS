//
//  OnboardingStep3ViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/08/31.
//

import UIKit
import RxSwift

class OnboardingStep3ViewController: UIViewController {
  
  private let bag = DisposeBag()
  
  private let changeWindow = ChangeWindow(),
              setNext = NextButtonStatus()
  
  // MARK: Model
  private let onboardingModel = OnboardingModel.shared
  
  // MARK: ViewModel
  private let onboardingViewModel = OnboardingViewModel()
  
  // MARK: View
  
  private let gameMarkImageView = UIImageView().then {
    $0.image = UIImage(named: OnboardingModel.myGame.lol.rawValue)
    $0.layer.cornerRadius = CommonLength.shared.width(37) / 2
    $0.backgroundColor = .blue
  }
  
  private let topLabel = UILabel().then {
    $0.text = "게임 아이디를"
    $0.textColor = .black
    $0.font = UIFont.joinuns.font(size: 34)
  }
  
  private let bottomLabel = UILabel().then {
    $0.text = "알려주세요."
    $0.textColor = .black
    $0.font = UIFont.joinuns.font(size: 34)
  }
 
  private let gameIdInputtextField = UITextField().then {
    
    let strNumber: NSString = "게임에서 사용하는 아이디를 입력해주세요." as NSString,
        range = (strNumber).range(of: "게임에서 사용하는 아이디를 입력해주세요."),
        font = UIFont.joinuns.font(size: 15),
        color = UIColor.joinusColor.gameIdTextFieldPlaceholderGray,
        attribute = NSMutableAttributedString.init(string: "게임에서 사용하는 아이디를 입력해주세요.")
    
    attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
    attribute.addAttribute(kCTFontAttributeName as NSAttributedString.Key, value: font, range: range)
    
    $0.attributedPlaceholder = attribute
    $0.placeholder = "게임에서 사용하는 아이디를 입력해주세요."
    $0.font = font
    $0.textColor = .black
    $0.backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
    $0.layer.cornerRadius = 2
    $0.addLeftPadding(width: CommonLength.shared.width(15))
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
    $0.keyboardAppearance = UIKeyboardAppearance.light
  }
  
  private let clearButton = UIButton().then {
    $0.setImage(UIImage(named: "group12"),
                for: .normal)
    $0.isHidden = true
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
  
  override func loadView() {
    super.loadView()
    
    self.onboardingViewModel
      .bindInputGameID()
    
    self.onboardingViewModel
      .      enableStep4outputSubject
      .asObservable()
      .bind(onNext: { isEnable in
        
        self.nextButton.isEnabled = isEnable
        self.setNext.buttonStatus(nextButton: self.nextButton)
        
      }).disposed(by: self.bag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.setupUI()
    self.textFieldStatus()
    self.didTapClearButton()
    self.setNavigationBar()
    self.inputBarButton()
    self.tapDoneButton()
    self.popViewController()
    self.didTapNextButton()
  }
  
  private func setupUI() {
    [gameMarkImageView, topLabel, bottomLabel, gameIdInputtextField, nextButton].forEach { self.view.addSubview($0) }
    
    self.view.addSubview(clearButton)
    
    gameMarkImageView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(CommonLength.shared.height(40))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
      $0.width.height.equalTo(CommonLength.shared.width(37))
    }
    
    topLabel.snp.makeConstraints {
      $0.centerY.equalTo(gameMarkImageView).offset(-5)
      $0.leading.equalTo(gameMarkImageView.snp.trailing).offset(CommonLength.shared.width(7))
    }
    
    bottomLabel.snp.makeConstraints {
      $0.top.equalTo(topLabel.snp.bottom).offset(CommonLength.shared.height(5))
      $0.leading.equalTo(gameMarkImageView)
    }
    
    gameIdInputtextField.snp.makeConstraints {
      $0.top.equalTo(bottomLabel.snp.bottom).offset(CommonLength.shared.height(60))
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(50))
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(200))
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.height.equalTo(CommonLength.shared.height(50))
    }
    
    clearButton.snp.makeConstraints {
      $0.centerY.equalTo(self.gameIdInputtextField)
      $0.width.height.equalTo(CommonLength.shared.width(23))
      $0.trailing.equalTo(self.gameIdInputtextField).offset(-CommonLength.shared.width(15))
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
    self.toolBarView.addSubview(partitionView)
    
    self.toolBarView.frame = CGRect(x: 0, y:0,
                                    width: CommonLength.shared.width(375),
                                    height: CommonLength.shared.height(35))
    
    customOkBarButtonItem.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(17))
      $0.width.equalTo(CommonLength.shared.width(50))
      $0.height.equalTo(CommonLength.shared.height(30))
    }
    
    partitionView.snp.makeConstraints {
      $0.height.equalTo(0.5)
      $0.width.centerX.equalToSuperview()
      $0.bottom.equalTo(self.toolBarView.snp.top)
    }
    
    self.gameIdInputtextField.inputAccessoryView = self.toolBarView
  }
  
  private func textFieldStatus() {
    
    self.gameIdInputtextField
      .rx
      .controlEvent(.editingChanged)
      .asDriver()
      .drive(onNext: {
        
        guard let text = self.gameIdInputtextField.text else { return print("text field text return") }
        
        if self.gameIdInputtextField.hasText {
        
          self.clearButton.isHidden = false
          
        } else {
          
          self.clearButton.isHidden = true
        }
        
        self.onboardingViewModel
          .inputGameID
          .onNext(text)
        
      }).disposed(by: self.bag)
  }
  
  private func didTapClearButton() {
    
    self.clearButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.gameIdInputtextField.text?.removeAll()
        self.clearButton.isHidden = true
        
      }).disposed(by: self.bag)
  }
  
  private func tapDoneButton() {
    
    self.customOkBarButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        guard let text = self.gameIdInputtextField.text else { return print("text field text return") }
        
        self.onboardingModel
          .myGameID = text
        
        self.view.endEditing(true)
        
      }).disposed(by: self.bag)
  }
  
  private func popViewController() {
    self.leftButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.gameIdInputtextField.text?.removeAll()
        
        self.navigationController?
          .popViewController(animated: true)
        
      }).disposed(by: self.bag)
  }
  
  private func didTapNextButton() {
    
    let onboardingStep4VC = OnboardingStep4ViewController()
    
    CommonAction.shared.touchActionEffect(self.nextButton) {
      
      if self.nextButton.isEnabled {
        
        self.navigationController?
          .pushViewController(onboardingStep4VC,
                              animated: true)
      }
    }
  }
}
