//
//  OnboardingStep2ViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/08/31.
//

import UIKit
import RxSwift

class OnboardingStep2ViewController: UIViewController {
  
  private let bag = DisposeBag()
  
  private let changeWindow = ChangeWindow(),
              setNext = NextButtonStatus()
  
  // MARK: Model
  private let onboardingModel = OnboardingModel.shared
  
  // MARK: ViewModel
  private let onboardingViewModel = OnboardingViewModel()
  
  // MARK: View
  private let titleLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.text = "어떤 게임을\n즐기시나요?"
    $0.textColor = .black
    $0.font = UIFont.joinuns.font(size: 34)
    $0.lineSpacing(spacing: 5,
                   alignment: .left)
  }
  
  private let lolButton = GameSelectButton(game: .lol).then {
    $0.backgroundColor = .red
  }
  
  private let ovchButton = GameSelectButton(game: .overWatch).then {
    $0.backgroundColor = .blue
  }
  
  private let suddenButton = GameSelectButton(game: .sudden).then {
    $0.backgroundColor = .yellow
  }
  
  private let bagButton = GameSelectButton(game: .battleGround).then {
    $0.backgroundColor = .darkGray
  }
  
  private let mapleButton = GameSelectButton(game: .mapleStory).then {
    $0.backgroundColor = .cyan
  }
  
  
  private let gudieLabel = UILabel().then {
    $0.text = "\u{2A} 나중에 마이페이지에서 게임을 추가할 수 있어요!"
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
      .bindCheckMyGame()
    
    self.onboardingViewModel
      .enableStep3outputSubject
      .asObservable()
      .bind(onNext: { isEnable in
        self.nextButton.isEnabled = isEnable
        self.setNext.buttonStatus(nextButton: self.nextButton)
      }).disposed(by: bag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.setupUI()
    self.setNavigationBar()
    self.popViewController()
    self.didTapGameButton()
    self.didTapNextButton()
  }
  
  private func setupUI() {
    [titleLabel,
     lolButton, ovchButton, suddenButton, bagButton, mapleButton,
     gudieLabel, nextButton].forEach { self.view.addSubview($0) }
    
    let buttonSize = CommonLength.shared.width(60)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(CommonLength.shared.height(40))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
      $0.width.equalToSuperview().multipliedBy(0.9)
    }
    
    lolButton.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(CommonLength.shared.height(25))
      $0.leading.equalTo(titleLabel)
      $0.width.height.equalTo(buttonSize)
    }
    
    ovchButton.snp.makeConstraints {
      $0.top.equalTo(lolButton)
      $0.leading.equalTo(lolButton.snp.trailing).offset(CommonLength.shared.width(20))
      $0.width.height.equalTo(buttonSize)
    }
    
    suddenButton.snp.makeConstraints {
      $0.top.equalTo(lolButton)
      $0.leading.equalTo(ovchButton.snp.trailing).offset(CommonLength.shared.width(20))
      $0.width.height.equalTo(buttonSize)
    }
    
    bagButton.snp.makeConstraints {
      $0.top.equalTo(lolButton)
      $0.leading.equalTo(suddenButton.snp.trailing).offset(CommonLength.shared.width(20))
      $0.width.height.equalTo(buttonSize)
    }
    
    mapleButton.snp.makeConstraints {
      $0.top.equalTo(lolButton.snp.bottom).offset(CommonLength.shared.height(20))
      $0.leading.equalTo(lolButton)
      $0.width.height.equalTo(buttonSize)
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
        
        [self.lolButton,
         self.ovchButton,
         self.suddenButton,
         self.bagButton,
         self.mapleButton].forEach {
          
          $0.isSelected = false
        }
         
        self.onboardingViewModel
          .selectMyGameInputSubject
          .onNext(String())
        
        self.navigationController?
          .popViewController(animated: true)
        
      }).disposed(by: self.bag)
  }
  
  private func didTapGameButton() {
    
    let game = OnboardingModel.myGame.self,
        isSelect = true
    
    Observable
      .of(self.lolButton.rx.tap.map { game.lol },
          self.bagButton.rx.tap.map { game.battleGround },
          self.suddenButton.rx.tap.map { game.sudden },
          self.ovchButton.rx.tap.map { game.overWatch },
          self.mapleButton.rx.tap.map { game.mapleStory })
      .merge()
      .asDriver(onErrorJustReturn: .lol)
      .drive { myGame in
        
        switch myGame {
        
          case .lol:
            
            self.lolButton.isSelected = isSelect
            self.bagButton.isSelected = !isSelect
            self.suddenButton.isSelected = !isSelect
            self.ovchButton.isSelected = !isSelect
            self.mapleButton.isSelected = !isSelect
            
          case .sudden:
            
            self.lolButton.isSelected = !isSelect
            self.suddenButton.isSelected = isSelect
            self.ovchButton.isSelected = !isSelect
            self.bagButton.isSelected = !isSelect
            self.mapleButton.isSelected = !isSelect
            
          case .overWatch:
            
            self.lolButton.isSelected = !isSelect
            self.suddenButton.isSelected = !isSelect
            self.ovchButton.isSelected = isSelect
            self.bagButton.isSelected = !isSelect
            self.mapleButton.isSelected = !isSelect
            
          case .battleGround:
            
            self.lolButton.isSelected = !isSelect
            self.suddenButton.isSelected = !isSelect
            self.ovchButton.isSelected = !isSelect
            self.bagButton.isSelected = isSelect
            self.mapleButton.isSelected = !isSelect
            
          case .mapleStory:
            
            self.lolButton.isSelected = !isSelect
            self.suddenButton.isSelected = !isSelect
            self.ovchButton.isSelected = !isSelect
            self.bagButton.isSelected = !isSelect
            self.mapleButton.isSelected = isSelect
        }
        
        self.onboardingViewModel
          .selectMyGameInputSubject
          .onNext(myGame.rawValue)
          
      }.disposed(by: self.bag)
  }
  
  private func didTapNextButton() {
    
    let onboardingStept3VC = OnboardingStep3ViewController()
    
    CommonAction.shared.touchActionEffect(self.nextButton) {
      
      if self.nextButton.isEnabled {
        
        self.navigationController?
          .pushViewController(onboardingStept3VC,
                              animated: true)
      }
    }
  }
}
