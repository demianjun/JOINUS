//
//  MakeMatchingViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/11.
//

import UIKit
import RxSwift

class MakeMatchingViewController: UIViewController {
  private let bag = DisposeBag()
  
  // MARK: ViewModel
  private let makeMatchingViewModel = MakeMatchingViewModel()
  
  // MARK: Model
  private let makeMatchingModel = MakeMatchingModel.shared
  
  // MARK: View
  private let navigationView = CustomNavigationView()
  
  private let makeMatchingScrollView = MakeMatchingScrollView()
  
  private let leftButtonItem = UIButton().then {
    $0.setImage(UIImage(named: "x_mark"),
                for: .normal)
    $0.tintColor = .black
  }
  
  private let rightButtonItem = UIButton().then {
    $0.setTitle("확인",
                for: .normal)
    $0.setTitleColor(UIColor.joinusColor.joinBlue,
                     for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 19)
  }
  
  private let naviBarTitleLabel = UILabel().then {
    $0.text = "매칭 만들기"
    $0.font = UIFont.joinuns.font(size: 19)
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  override func loadView() {
    super.loadView()
    self.makeMatchingViewModel
      .bindCountJoinPeople()
    
    self.makeMatchingViewModel
      .outputCountJoinPeople
      .bind(to: self.makeMatchingScrollView
              .useCountJoinPeopleView()
              .useCountLabel()
              .rx.text)
      .disposed(by: self.bag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = #colorLiteral(red: 0.8783445954, green: 0.8784921765, blue: 0.8783251643, alpha: 1)
    self.setupView()
    self.setNavigationBar()
    self.popViewController()
    self.didTapCountButton()
    self.didTapGameButton()
    self.didTapVoiceChatButton()
  }
  
  private func setupView() {
    [navigationView, makeMatchingScrollView].forEach { self.view.addSubview($0) }
    
    navigationView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(100))
    }
    
    makeMatchingScrollView.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom).offset(CommonLength.shared.height(3))
      $0.width.centerX.bottom.equalToSuperview()
    }
  }
  
  private func setNavigationBar() {
    [leftButtonItem, naviBarTitleLabel, rightButtonItem].forEach { self.navigationView.addSubview($0) }
    
    naviBarTitleLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(20))
      $0.centerX.equalToSuperview()
    }
    
    leftButtonItem.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
      $0.centerY.equalTo(naviBarTitleLabel)
      $0.width.height.equalTo(CommonLength.shared.width(15))
    }
    
    rightButtonItem.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(17))
      $0.centerY.equalTo(naviBarTitleLabel)
      $0.width.equalTo(CommonLength.shared.width(35))
      $0.height.equalTo(CommonLength.shared.height(25))
    }
    
    self.tabBarController?.tabBar.isHidden = true
    self.navigationController?.navigationBar.isHidden = true
  }
  
  func didTapCountButton() {
   
    let countJoinPeopleView = self.makeMatchingScrollView.useCountJoinPeopleView(),
        countUpButton = countJoinPeopleView.useCountUpButton(),
        countDownButton = countJoinPeopleView.useCountDownButton()
    
    Observable.of(countUpButton.rx.tap.map { MakeMatchingModel.countType.up },
                  countDownButton.rx.tap.map { MakeMatchingModel.countType.down })
      .merge()
      .asDriver(onErrorJustReturn: .up)
      .drive { countType in
       
        self.makeMatchingViewModel
          .inputCountUpJoinPeople
          .onNext(countType)
        
      }.disposed(by: self.bag)
  }
  
  private func popViewController() {
    self.leftButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.navigationController?
          .popViewController(animated: true)
        
        self.tabBarController?.tabBar.isHidden = false
        
      }).disposed(by: self.bag)
  }
  
  private func didTapGameButton() {
    
    let game = OnboardingModel.myGame.self,
        gameButtonScrollView = self.makeMatchingScrollView.useSelectGameView().useGameScrollView(),
        lolButton = gameButtonScrollView.useSelectGameButton(game: .lol),
        bagButton = gameButtonScrollView.useSelectGameButton(game: .battleGround),
        suddenButton = gameButtonScrollView.useSelectGameButton(game: .suddenAttack),
        ovchButton = gameButtonScrollView.useSelectGameButton(game: .overwatch),
        mapleButton = gameButtonScrollView.useSelectGameButton(game: .mapleStory),
        isSelect = true

    Observable
      .of(lolButton.rx.tap.map { game.lol },
          bagButton.rx.tap.map { game.battleGround },
          suddenButton.rx.tap.map { game.suddenAttack },
          ovchButton.rx.tap.map { game.overwatch },
          mapleButton.rx.tap.map { game.mapleStory })
      .merge()
      .asDriver(onErrorJustReturn: .lol)
      .drive { selectGame in

        self.makeMatchingModel.selectedGame = selectGame.rawValue

        switch selectGame {

          case .lol:

            lolButton.isSelected = isSelect
            bagButton.isSelected = !isSelect
            suddenButton.isSelected = !isSelect
            ovchButton.isSelected = !isSelect
            mapleButton.isSelected = !isSelect

          case .suddenAttack:

            lolButton.isSelected = !isSelect
            suddenButton.isSelected = isSelect
            ovchButton.isSelected = !isSelect
            bagButton.isSelected = !isSelect
            mapleButton.isSelected = !isSelect

          case .overwatch:

            lolButton.isSelected = !isSelect
            suddenButton.isSelected = !isSelect
            ovchButton.isSelected = isSelect
            bagButton.isSelected = !isSelect
            mapleButton.isSelected = !isSelect

          case .battleGround:

            lolButton.isSelected = !isSelect
            suddenButton.isSelected = !isSelect
            ovchButton.isSelected = !isSelect
            bagButton.isSelected = isSelect
            mapleButton.isSelected = !isSelect

          case .mapleStory:

            lolButton.isSelected = !isSelect
            suddenButton.isSelected = !isSelect
            ovchButton.isSelected = !isSelect
            bagButton.isSelected = !isSelect
            mapleButton.isSelected = isSelect
        }
      }.disposed(by: self.bag)
  }
  
  private func didTapVoiceChatButton() {
  
    enum isVoiceChat {
      case possible, impossible
    }
    
    let selectVoiceChatView = self.makeMatchingScrollView.useSelectVoiceChatView(),
        possibilityButton = selectVoiceChatView.usePossibilityButton(),
        impossibilityButton = selectVoiceChatView.useImpossibilityButton(),
        isSelect = true
    
    Observable
      .of(possibilityButton.rx.tap.map { isVoiceChat.possible },
          impossibilityButton.rx.tap.map { isVoiceChat.impossible })
      .merge()
      .asObservable()
      .bind { isVoiceChat in
        
        switch isVoiceChat {
          
          case .possible:
            
            possibilityButton.isSelected = isSelect
            impossibilityButton.isSelected = !isSelect
            
          case .impossible:
            
            possibilityButton.isSelected = !isSelect
            impossibilityButton.isSelected = isSelect
        }
        
        self.makeMatchingModel.isVoiceChat = possibilityButton.isSelected
        
      }.disposed(by: self.bag)
  }
}
