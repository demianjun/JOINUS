//
//  ProfileViewControllerViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/02.
//

import UIKit
import RxSwift

class ProfileViewControllerViewController: UIViewController {
  
  private let bag = DisposeBag()
  
  private let changeWindow = ChangeWindow(),
              chnageVC = ChangeViewController(),
              setNext = NextButtonStatus()
  
  private let tapGesture = UITapGestureRecognizer()
  
  // MARK: Manager
//  private let service = Service.manager
  
  private let onBoarding = OnboardingService.manager
  private let game = GameService.manager
  
  // MARK: Model
  private let onboardingModel = OnboardingModel.shared,
              myInfoModel = MyInfoModel.shared
  
  // MARK: ViewModel
  public let onboardingViewModel = OnboardingViewModel()
  
  private let joinusAlertVC = JoinusAlertViewController()
  
  // MARK: View
  private let titleLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.text = "프로필 사진을\n설정해 주세요."
    $0.textColor = .black
    $0.font = UIFont.joinuns.font(size: 34)
    $0.lineSpacing(spacing: 5,
                   alignment: .left)
  }
  
  private let profilePhotoView = ProfilePhotoView().then {
    $0.isUserInteractionEnabled = true
  }
  
  private let gudieLabel = UILabel().then {
    $0.text = "\u{2A} 프로필은 마이페이지에서도 변경하실 수 있습니다."
    $0.textColor = UIColor.joinusColor.genderDeselectedGray
    $0.font = UIFont.joinuns.font(size: 11)
  }
  
  private let nextButton = UIButton().then {
    $0.setTitle("확인",
                for: .normal)
    $0.setTitleColor(.white,
                     for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 15)
    $0.layer.cornerRadius = 2
    $0.backgroundColor = UIColor.joinusColor.joinBlue
  }
  
  private let leftButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                               style: .plain,
                                               target: nil,
                                               action: nil)
  
  override func loadView() {
    super.loadView()
    self.joinusAlertVC
      .onboardingViewModel
      .bindSelectProfileImage()
    
    self.joinusAlertVC
      .onboardingViewModel
      .myProfileImageOutputSubject
      .bind(to: self.profilePhotoView.useProfileImageView().rx.image)
      .disposed(by: self.bag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.setNavigationBar()
    self.setupUI()
    self.didTapProfileView()
    self.popViewController()
    self.didTapNextButton()
  }
  
  private func setupUI() {
    [titleLabel,
     profilePhotoView,
     gudieLabel,
     nextButton].forEach { self.view.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(CommonLength.shared.height(40))
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.9)
    }
    
    profilePhotoView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(CommonLength.shared.height(60))
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(CommonLength.shared.width(100))
    }
    
    gudieLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(nextButton.snp.top).offset(-CommonLength.shared.height(10))
    }

    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(200))
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(17))
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.height.equalTo(CommonLength.shared.height(50))
    }
    
    self.profilePhotoView.addGestureRecognizer(self.tapGesture)
  }
  
  private func setNavigationBar() {
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationController?.navigationBar.topItem?.title = ""
    self.navigationItem.leftBarButtonItem = self.leftButtonItem
  }
  
  private func didTapNextButton() {
    self.myInfoModel.myAge = 25
    self.myInfoModel.myGender = 0
    self.myInfoModel.myGameID = "PreyIOS"
    self.myInfoModel.subToken = "109112693255361562533"

    self.myInfoModel.myGameID = "PreyIOS"
    self.myInfoModel.myGameName = "PreyIOS"
    self.myInfoModel.gameInfoPk = 0
    self.myInfoModel.myTier = 2
    self.myInfoModel.myPk = 7
    
    
    let setTabbarController = SetTabbarController()

    CommonAction.shared.touchActionEffect(self.nextButton) {
      
      if self.nextButton.isEnabled {
        
//        self.onBoarding.putOnboarding {
//
//          self.game.postGame {
            
            setTabbarController.settingRootViewController()
//          }
//        }
      }
    }
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
  
  private func popViewController() {
    self.leftButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.navigationController?
          .popViewController(animated: true)
        
      }).disposed(by: self.bag)
  }
}
