//
//  OnboardingStep4ViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/02.
//

import UIKit
import RxSwift

class OnboardingStep4ViewController: UIViewController {
  
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
    $0.text = "당신의 게임실력을"
    $0.textColor = .black
    $0.font = UIFont.joinuns.font(size: 34)
  }
  
  private let bottomLabel = UILabel().then {
    $0.text = "알려주세요."
    $0.textColor = .black
    $0.font = UIFont.joinuns.font(size: 34)
  }
  
  private let ironButton = SelectTierButton(tier: .iron).then {
    $0.useTierImageView().backgroundColor = .blue
  }
  
  private let bronzeButton = SelectTierButton(tier: .bronze).then {
    $0.useTierImageView().backgroundColor = .red
  }
  
  private let silverButton = SelectTierButton(tier: .silver).then {
    $0.useTierImageView().backgroundColor = .cyan
  }
  
  private let goldButton = SelectTierButton(tier: .gold).then {
    $0.useTierImageView().backgroundColor = .yellow
  }
  
  private let platinumButton = SelectTierButton(tier: .platinum).then {
    $0.useTierImageView().backgroundColor = .darkGray
  }
  
  private let diamondButton = SelectTierButton(tier: .diamond).then {
    $0.useTierImageView().backgroundColor = .brown
  }
  
  private let masterButton = SelectTierButton(tier: .master).then {
    $0.useTierImageView().backgroundColor = .orange
  }
  
  private let challengerButton = SelectTierButton(tier: .challenger).then {
    $0.useTierImageView().backgroundColor = .magenta
  }
  
  private let gudieLabel = UILabel().then {
    $0.text = "\u{2A} 적합한 매칭을 위해 정확한 정보를 입력해 주세요."
    $0.textColor = UIColor.joinusColor.genderDeselectedGray
    $0.font = UIFont.joinuns.font(size: 11)
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
  
  override func loadView() {
    super.loadView()
    
    self.onboardingViewModel
      .bindInputMyTier()
    
    self.onboardingViewModel
      .enableProfileVCoutputSubject
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
    self.setNavigationBar()
    self.didTapTierButton()
    self.popViewController()
    self.didTapNextButton()
  }
  
  private func setupUI() {
    [gameMarkImageView, topLabel, bottomLabel,
     ironButton, bronzeButton, silverButton, goldButton,
     platinumButton, diamondButton, masterButton, challengerButton,
     gudieLabel,
     nextButton].forEach { self.view.addSubview($0) }
    
    let buttonWidth = CommonLength.shared.width(48),
        buttonHeight = CommonLength.shared.height(58)
    
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
    
    ironButton.snp.makeConstraints {
      $0.top.equalTo(bottomLabel.snp.bottom).offset(CommonLength.shared.height(30))
      $0.leading.equalTo(gameMarkImageView)
      $0.width.equalTo(buttonWidth)
      $0.height.equalTo(buttonHeight)
    }
    
    bronzeButton.snp.makeConstraints {
      $0.top.equalTo(ironButton)
      $0.leading.equalTo(ironButton.snp.trailing).offset(CommonLength.shared.width(17))
      $0.width.equalTo(buttonWidth)
      $0.height.equalTo(buttonHeight)
    }
    
    silverButton.snp.makeConstraints {
      $0.top.equalTo(ironButton)
      $0.leading.equalTo(bronzeButton.snp.trailing).offset(CommonLength.shared.width(17))
      $0.width.equalTo(buttonWidth)
      $0.height.equalTo(buttonHeight)
    }
    
    goldButton.snp.makeConstraints {
      $0.top.equalTo(ironButton)
      $0.leading.equalTo(silverButton.snp.trailing).offset(CommonLength.shared.width(17))
      $0.width.equalTo(buttonWidth)
      $0.height.equalTo(buttonHeight)
    }
    
    platinumButton.snp.makeConstraints {
      $0.top.equalTo(ironButton.snp.bottom).offset(CommonLength.shared.height(30))
      $0.leading.equalTo(gameMarkImageView)
      $0.width.equalTo(buttonWidth)
      $0.height.equalTo(buttonHeight)
    }
    
    diamondButton.snp.makeConstraints {
      $0.top.equalTo(platinumButton)
      $0.leading.equalTo(platinumButton.snp.trailing).offset(CommonLength.shared.width(17))
      $0.width.equalTo(buttonWidth)
      $0.height.equalTo(buttonHeight)
    }
    
    masterButton.snp.makeConstraints {
      $0.top.equalTo(platinumButton)
      $0.leading.equalTo(diamondButton.snp.trailing).offset(CommonLength.shared.width(17))
      $0.width.equalTo(buttonWidth)
      $0.height.equalTo(buttonHeight)
    }
    
    challengerButton.snp.makeConstraints {
      $0.top.equalTo(platinumButton)
      $0.leading.equalTo(masterButton.snp.trailing).offset(CommonLength.shared.width(17))
      $0.width.equalTo(buttonWidth)
      $0.height.equalTo(buttonHeight)
    }
    
    gudieLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(nextButton.snp.top).offset(-CommonLength.shared.height(10))
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(200))
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.height.equalTo(CommonLength.shared.height(50))
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
        
        [self.ironButton,
         self.bronzeButton,
         self.silverButton,
         self.goldButton,
         self.platinumButton,
         self.diamondButton,
         self.masterButton,
         self.challengerButton].forEach {
          
          $0.isSelected = false
         }
        
        self.onboardingViewModel
          .inputMyTier
          .onNext(String())
        
        self.navigationController?
          .popViewController(animated: true)
        
      }).disposed(by: self.bag)
  }
  
  private func didTapTierButton() {
    
    let tier = OnboardingModel.myTier.self,
        isSelect = true
    
    var selectTier = Int()
    
    Observable
      .of(self.ironButton.rx.tap.map { tier.iron },
          self.bronzeButton.rx.tap.map { tier.bronze },
          self.silverButton.rx.tap.map { tier.silver },
          self.goldButton.rx.tap.map { tier.gold },
          self.platinumButton.rx.tap.map { tier.platinum },
          self.diamondButton.rx.tap.map { tier.diamond },
          self.masterButton.rx.tap.map { tier.master },
          self.challengerButton.rx.tap.map { tier.challenger })
      .merge()
      .asDriver(onErrorJustReturn: .iron)
      .drive { myTier in
        
        switch myTier {
          
          case .iron:
            self.ironButton.isSelected = isSelect
            self.bronzeButton.isSelected = !isSelect
            self.silverButton.isSelected = !isSelect
            self.goldButton.isSelected = !isSelect
            self.platinumButton.isSelected = !isSelect
            self.diamondButton.isSelected = !isSelect
            self.masterButton.isSelected = !isSelect
            self.challengerButton.isSelected = !isSelect
            
            selectTier = 0
            
          case .bronze:
            self.ironButton.isSelected = !isSelect
            self.bronzeButton.isSelected = isSelect
            self.silverButton.isSelected = !isSelect
            self.goldButton.isSelected = !isSelect
            self.platinumButton.isSelected = !isSelect
            self.diamondButton.isSelected = !isSelect
            self.masterButton.isSelected = !isSelect
            self.challengerButton.isSelected = !isSelect
            
            selectTier = 1
            
          case .silver:
            self.ironButton.isSelected = !isSelect
            self.bronzeButton.isSelected = !isSelect
            self.silverButton.isSelected = isSelect
            self.goldButton.isSelected = !isSelect
            self.platinumButton.isSelected = !isSelect
            self.diamondButton.isSelected = !isSelect
            self.masterButton.isSelected = !isSelect
            self.challengerButton.isSelected = !isSelect
            
            selectTier = 2
            
          case .gold:
            self.ironButton.isSelected = !isSelect
            self.bronzeButton.isSelected = !isSelect
            self.silverButton.isSelected = !isSelect
            self.goldButton.isSelected = isSelect
            self.platinumButton.isSelected = !isSelect
            self.diamondButton.isSelected = !isSelect
            self.masterButton.isSelected = !isSelect
            self.challengerButton.isSelected = !isSelect
            
            selectTier = 3
            
          case .platinum:
            self.ironButton.isSelected = !isSelect
            self.bronzeButton.isSelected = !isSelect
            self.silverButton.isSelected = !isSelect
            self.goldButton.isSelected = !isSelect
            self.platinumButton.isSelected = isSelect
            self.diamondButton.isSelected = !isSelect
            self.masterButton.isSelected = !isSelect
            self.challengerButton.isSelected = !isSelect
            
            selectTier = 4
            
          case .diamond:
            self.ironButton.isSelected = !isSelect
            self.bronzeButton.isSelected = !isSelect
            self.silverButton.isSelected = !isSelect
            self.goldButton.isSelected = !isSelect
            self.platinumButton.isSelected = !isSelect
            self.diamondButton.isSelected = isSelect
            self.masterButton.isSelected = !isSelect
            self.challengerButton.isSelected = !isSelect
            
            selectTier = 5
            
          case .master:
            self.ironButton.isSelected = !isSelect
            self.bronzeButton.isSelected = !isSelect
            self.silverButton.isSelected = !isSelect
            self.goldButton.isSelected = !isSelect
            self.platinumButton.isSelected = !isSelect
            self.diamondButton.isSelected = !isSelect
            self.masterButton.isSelected = isSelect
            self.challengerButton.isSelected = !isSelect
            
            selectTier = 6
            
          case .challenger:
            self.ironButton.isSelected = !isSelect
            self.bronzeButton.isSelected = !isSelect
            self.silverButton.isSelected = !isSelect
            self.goldButton.isSelected = !isSelect
            self.platinumButton.isSelected = !isSelect
            self.diamondButton.isSelected = !isSelect
            self.masterButton.isSelected = !isSelect
            self.challengerButton.isSelected = isSelect
            
            selectTier = 7
            
        }
        
        self.onboardingModel
          .myTier = selectTier
        
        self.onboardingViewModel
          .inputMyTier
          .onNext(myTier.rawValue)
        
      }.disposed(by: self.bag)
  }
  
  private func didTapNextButton() {
    
    let profileVC = ProfileViewControllerViewController()
    
    CommonAction.shared.touchActionEffect(self.nextButton) {
      
      if self.nextButton.isEnabled {
        
        self.navigationController?
          .pushViewController(profileVC,
                              animated: true)
      }
    }
  }
}
