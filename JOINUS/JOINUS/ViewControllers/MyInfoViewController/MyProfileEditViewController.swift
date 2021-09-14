//
//  MyProfileEditViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/14.
//

import UIKit
import RxSwift

class MyProfileEditViewController: UIViewController, UITextFieldDelegate {
  private let bag = DisposeBag()
  
  private let game = GameService.manager
  
  private let tapGesture = UITapGestureRecognizer()
  
  // MARK: ViewModel
  public let myInfoViewModel = MyInfoViewModel()
  
  // MARK: Model
  private let myInfoModel = MyInfoModel.shared
  
  // MARK: View
  private let navigationView = CustomNavigationView()
  
  private let profilePhotoView = ProfilePhotoView().then {
    $0.isUserInteractionEnabled = true
  }
  
  private let gameIdEditTextField = UITextField().then {
    
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
  
  private let joinusAlertVC = JoinusAlertViewController()
  
  private let leftButtonItem = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"),
                for: .normal)
    $0.tintColor = .black
    $0.transform = .init(scaleX: 1.5, y: 1.5)
  }
  
  private let naviBarTitleLabel = UILabel().then {
    $0.text = "프로필 수정"
    $0.font = UIFont.joinuns.font(size: 19)
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  // MARK: LifeCycle
  override func loadView() {
    super.loadView()
    self.myInfoViewModel
      .bindSelectProfileImage()
    
    self.myInfoViewModel
      .myProfileImageOutputSubject
      .bind(to: self.profilePhotoView.useProfileImageView().rx.image)
      .disposed(by: self.bag)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.gameIdEditTextField.delegate = self
    self.setupView()
    self.setNavigationBar()
    self.inputBarButton()
    self.didTapProfileView()
    self.textFieldStatus()
    self.didTapClearButton()
    self.didTapDoneButton()
    self.popViewController()
  }
  
  private func setupView() {
    [navigationView, profilePhotoView, gameIdEditTextField, clearButton].forEach { self.view.addSubview($0) }
    
    navigationView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(100))
    }
    
    profilePhotoView.snp.makeConstraints {
      $0.width.height.equalTo(CommonLength.shared.width(80))
      $0.top.equalTo(navigationView.snp.bottom).offset(CommonLength.shared.height(20))
      $0.centerX.equalToSuperview()
    }
    
    gameIdEditTextField.snp.makeConstraints {
      $0.top.equalTo(profilePhotoView.snp.bottom).offset(CommonLength.shared.height(20))
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(50))
    }
    
    clearButton.snp.makeConstraints {
      $0.centerY.equalTo(self.gameIdEditTextField)
      $0.width.height.equalTo(CommonLength.shared.width(23))
      $0.trailing.equalTo(self.gameIdEditTextField).offset(-CommonLength.shared.width(15))
    }
  }
  
  private func setNavigationBar() {
    [leftButtonItem, naviBarTitleLabel].forEach { self.navigationView.addSubview($0) }
    
    naviBarTitleLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(20))
      $0.centerX.equalToSuperview()
    }
    
    leftButtonItem.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
      $0.centerY.equalTo(naviBarTitleLabel)
      $0.width.height.equalTo(CommonLength.shared.width(15))
    }
    
    self.profilePhotoView.addGestureRecognizer(self.tapGesture)
    
    self.tabBarController?.tabBar.isHidden = true
    self.navigationController?.navigationBar.isHidden = true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    textField.resignFirstResponder()
    return true
  }
  
  private func didTapProfileView() {
    
    self.tapGesture
      .rx
      .event
      .asDriver()
      .drive(onNext: { tap in
        
        self.joinusAlertVC.modalPresentationStyle = .overFullScreen
        
        self.present(self.joinusAlertVC,
                     animated: false)
        
      }).disposed(by: self.bag)
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
    
    self.gameIdEditTextField.inputAccessoryView = self.toolBarView
  }
  
  private func textFieldStatus() {
    self.gameIdEditTextField.text = self.myInfoModel.myGameID
    
    if !self.gameIdEditTextField.text!.isEmpty {
      self.clearButton.isHidden = false
    }
    
    self.gameIdEditTextField
      .rx
      .controlEvent(.editingChanged)
      .asDriver()
      .drive(onNext: {
        
        if self.gameIdEditTextField.hasText {
        
          self.clearButton.isHidden = false
          
        } else {
          
          self.clearButton.isHidden = true
        }
      }).disposed(by: self.bag)
  }
  
  private func didTapClearButton() {
    
    self.clearButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.gameIdEditTextField.text?.removeAll()
        self.clearButton.isHidden = true
        
      }).disposed(by: self.bag)
  }
  
  private func didTapDoneButton() {
    
    self.customOkBarButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.view.endEditing(true)
        
      }).disposed(by: self.bag)
  }
  
  private func popViewController() {
    self.leftButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        guard let text = self.gameIdEditTextField.text else { return print("text field text return") }
        
        if !text.isEmpty {
          
          self.myInfoViewModel
            .inputEditMyGameID
            .onNext(text)
          
          self.myInfoModel.myGameID = text
        }
        
        self.game.putGame() {
          
          self.navigationController?
            .popViewController(animated: true)
          
          self.tabBarController?.tabBar.isHidden = false
        }
      }).disposed(by: self.bag)
  }
}
