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
  
  private let selectTierOfJoinPeopleVC = SelectTierOfJoinPeopleViewController()
  
  override func loadView() {
    super.loadView()
    let selectTierOfJoinPeopleViewModel = self.selectTierOfJoinPeopleVC.selectTierOfJoinPeopleViewModel
    
    self.makeMatchingViewModel
      .bindCountJoinPeople()
    
    self.makeMatchingViewModel
      .outputCountJoinPeople
      .bind(to: self.makeMatchingScrollView
              .useCountJoinPeopleView()
              .useCountLabel()
              .rx.text)
      .disposed(by: self.bag)
    
    self.makeMatchingViewModel
      .bindSetGameStartDate()
    
    self.makeMatchingViewModel
      .outputSetGameStartDate
      .bind(to: self.makeMatchingScrollView
              .useStartDateSetView()
              .useShowSettingDateLabel()
              .rx.text)
      .disposed(by: self.bag)
    
    selectTierOfJoinPeopleViewModel
      .bindSelectTierRagne()
    
    selectTierOfJoinPeopleViewModel
      .outputTierRange
      .bind {
        var range = String()
        if $0.count == 2 {
          range = "\($0[0]) > \($0[1])"
        } else {
          range = "\($0[0])"
        }
        
        self.makeMatchingScrollView
          .useSetJoinPeopleTierView()
          .useShowSettingTierLabel()
          .text = range
        
      }.disposed(by: self.bag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = #colorLiteral(red: 0.8783445954, green: 0.8784921765, blue: 0.8783251643, alpha: 1)
    self.setupView()
    self.setNavigationBar()
    self.popViewController()
    self.didTapCountButton()
    self.didTapChangeGameStartDate()
    self.didTapGameButton()
    self.didTapVoiceChatButton()
    self.didTapChangeTierRangeButton()
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
  
  private let okButton = JoinusButton(title: "설정",
                                      titleColor: .white,
                                      backGroundColor: UIColor.joinusColor.joinBlue),
    cancelButton = JoinusButton(title: "취소",
                                titleColor: UIColor.joinusColor.defaultPhotoGray,
                                backGroundColor: #colorLiteral(red: 0.8783445954, green: 0.8784921765, blue: 0.8783251643, alpha: 1))
  let datePicker = UIDatePicker()
  private func didTapChangeGameStartDate() {
    
    let changeDateButton = self.makeMatchingScrollView.useStartDateSetView().useChangeDateButton()
    
    changeDateButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
//        let datePicker = UIDatePicker()
        
        if #available(iOS 13.4, *) {
//          datePicker.preferredDatePickerStyle = .wheels
        } else {
          
        }
        self.datePicker.datePickerMode = .date
        self.datePicker.locale = Locale(identifier: "KO_kr")
        
        let joinusAlertVC = JoinusAlertController(title: .top,
                                                  title: "시작 날짜를 설정하세요.",
                                                  explain: "",
                                                  add: self.datePicker)
          
        joinusAlertVC.addAction(self.okButton)
        joinusAlertVC.addAction(self.cancelButton)
        
        self.present(joinusAlertVC,
                     animated: false)
        
      }).disposed(by: self.bag)
    self.didTapSetGameStartDateButton()
    self.didTapCancelButton()
  }
  
  private func didTapSetGameStartDateButton() {
    
    self.okButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.makeMatchingViewModel
          .inputGameStartDate
          .onNext(self.datePicker.date)
        
        self.makeMatchingModel
          .startGameDate = self.datePicker.date.toString()
        
        self.dismiss(animated: false)
        
      }).disposed(by: self.bag)
  }
  
  private func didTapCancelButton() {
    
    self.cancelButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.dismiss(animated: false)
        
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
              
  private func didTapChangeTierRangeButton() {
  
    let setJoniPeopleTierView = self.makeMatchingScrollView.useSetJoinPeopleTierView(),
        changeTierButton = setJoniPeopleTierView.useChangeTierButton()
    
    changeTierButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.navigationController?
          .pushViewController(self.selectTierOfJoinPeopleVC,
                              animated: true)
        
      }).disposed(by: self.bag)
  }
}
