//
//  SelectTierOfJoinPeopleViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/12.
//

import UIKit
import RxSwift

class SelectTierOfJoinPeopleViewController: UIViewController {
  enum tap: Int {
    case allTier = -1,
         iron = 0,
         bronze = 1,
         silver = 2,
         gold = 3,
         platinum = 4,
         dia = 5,
         master = 6,
         challenger = 7
    }
  
  private let bag = DisposeBag()
  
  // MARK: Model
  private let makeMatchingModel = MakeMatchingModel.shared
  
  // MARK: ViewModel
  public let selectTierOfJoinPeopleViewModel = SelectTierOfJoinPeopleViewModel()
  
  // MARK: View
  private let navigationView = CustomNavigationView()
  
  private let selectTierOfJoinPeopleScrollView = SelectTierOfJoinPeopleScrollView()
  
  private let leftButtonItem = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"),
                for: .normal)
    $0.tintColor = .black
    $0.transform = .init(scaleX: 1.5, y: 1.5)
  }
  
  private let naviBarTitleLabel = UILabel().then {
    $0.text = "참가자 티어"
    $0.font = UIFont.joinuns.font(size: 19)
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = #colorLiteral(red: 0.8783445954, green: 0.8784921765, blue: 0.8783251643, alpha: 1)
    self.setupView()
    self.setNavigationBar()
    self.popViewController()
    self.initTierRange()
    self.didTapSmallestTierRangeButton()
    self.didTapLargestTierRangeButton()
  }
  
  private func setupView() {
    [navigationView, selectTierOfJoinPeopleScrollView].forEach { self.view.addSubview($0) }
    
    navigationView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(100))
    }
    
    selectTierOfJoinPeopleScrollView.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom).offset(1)
      $0.width.centerX.bottom.equalToSuperview()
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
    
    self.navigationController?.navigationBar.isHidden = true
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
  
  private func initTierRange() {
    let lowestView = self.selectTierOfJoinPeopleScrollView.useSmallestTierRangeView(),
        lowestAllTierButton = lowestView.useAllTierSelectButton(),
        highetView = self.selectTierOfJoinPeopleScrollView.useLargestTierRangeView(),
        highestAllTierButton = highetView.useAllTierSelectButton()
    
    if (self.makeMatchingModel.lowestTier == 0),
       (self.makeMatchingModel.highestTier == 7) {
      
      lowestAllTierButton.isSelected = true
      highestAllTierButton.isSelected = true
      
    }
  }
  
  private func didTapSmallestTierRangeButton() {
    
    let lowestView = self.selectTierOfJoinPeopleScrollView.useSmallestTierRangeView(),
        allTierButton = lowestView.useAllTierSelectButton(),
        ironButton = lowestView.useTierRangeSelectButton(tier: .iron),
        bronzeButton = lowestView.useTierRangeSelectButton(tier: .bronze),
        silverButton = lowestView.useTierRangeSelectButton(tier: .silver),
        goldButton = lowestView.useTierRangeSelectButton(tier: .gold),
        platinumButton = lowestView.useTierRangeSelectButton(tier: .platinum),
        diaButton = lowestView.useTierRangeSelectButton(tier: .diamond),
        masterButton = lowestView.useTierRangeSelectButton(tier: .master),
        challengerButton = lowestView.useTierRangeSelectButton(tier: .challenger),
        isSelect = true
    
    Observable.of(allTierButton.rx.tap.map { tap.allTier },
                  ironButton.rx.tap.map { tap.iron },
                  bronzeButton.rx.tap.map { tap.bronze },
                  silverButton.rx.tap.map { tap.silver },
                  goldButton.rx.tap.map { tap.gold },
                  platinumButton.rx.tap.map { tap.platinum },
                  diaButton.rx.tap.map { tap.dia },
                  masterButton.rx.tap.map { tap.master },
                  challengerButton.rx.tap.map { tap.challenger })
      .merge()
      .asDriver(onErrorJustReturn: .allTier)
      .drive { rangeTier in
        
        self.selectTierOfJoinPeopleViewModel
          .inputSmallestTierRange
          .onNext(rangeTier.rawValue)
        
        self.makeMatchingModel.lowestTier = rangeTier.rawValue
        
        switch rangeTier {
          
          case .allTier:
            
            self.makeMatchingModel.lowestTier = 0
            
            allTierButton.isSelected = isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = !isSelect
            
          case .iron:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = !isSelect
            
          case .bronze:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = !isSelect
            
          case .silver:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = !isSelect
            
          case .gold:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = !isSelect
            
          case .platinum:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = !isSelect
            
          case .dia:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = !isSelect
            
          case .master:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = isSelect
            challengerButton.isSelected = !isSelect
            
          case .challenger:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = isSelect
        }
        
      }.disposed(by: self.bag)
  }
  
  private func didTapLargestTierRangeButton() {
    
    let highestView = self.selectTierOfJoinPeopleScrollView.useLargestTierRangeView(),
        allTierButton = highestView.useAllTierSelectButton(),
        ironButton = highestView.useTierRangeSelectButton(tier: .iron),
        bronzeButton = highestView.useTierRangeSelectButton(tier: .bronze),
        silverButton = highestView.useTierRangeSelectButton(tier: .silver),
        goldButton = highestView.useTierRangeSelectButton(tier: .gold),
        platinumButton = highestView.useTierRangeSelectButton(tier: .platinum),
        diaButton = highestView.useTierRangeSelectButton(tier: .diamond),
        masterButton = highestView.useTierRangeSelectButton(tier: .master),
        challengerButton = highestView.useTierRangeSelectButton(tier: .challenger),
        isSelect = true
    
    Observable.of(allTierButton.rx.tap.map { tap.allTier },
                  ironButton.rx.tap.map { tap.iron },
                  bronzeButton.rx.tap.map { tap.bronze },
                  silverButton.rx.tap.map { tap.silver },
                  goldButton.rx.tap.map { tap.gold },
                  platinumButton.rx.tap.map { tap.platinum },
                  diaButton.rx.tap.map { tap.dia },
                  masterButton.rx.tap.map { tap.master },
                  challengerButton.rx.tap.map { tap.challenger })
      .merge()
      .asDriver(onErrorJustReturn: .allTier)
      .drive { rangeTier in
        
        self.selectTierOfJoinPeopleViewModel
          .inputLargestTierRange
          .onNext(rangeTier.rawValue)
        
        self.makeMatchingModel.highestTier = rangeTier.rawValue
        
        switch rangeTier {
          
          case .allTier:
            
            self.makeMatchingModel.highestTier = 7
            
            allTierButton.isSelected = isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = !isSelect
            
          case .iron:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = !isSelect
            
          case .bronze:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = !isSelect
            
          case .silver:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = !isSelect
            
          case .gold:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = !isSelect
            
          case .platinum:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = !isSelect
            
          case .dia:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = !isSelect
            
          case .master:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = isSelect
            challengerButton.isSelected = !isSelect
            
          case .challenger:
            
            allTierButton.isSelected = !isSelect
            ironButton.isSelected = !isSelect
            bronzeButton.isSelected = !isSelect
            silverButton.isSelected = !isSelect
            goldButton.isSelected = !isSelect
            platinumButton.isSelected = !isSelect
            diaButton.isSelected = !isSelect
            masterButton.isSelected = !isSelect
            challengerButton.isSelected = isSelect
        }
        
      }.disposed(by: self.bag)
  }
}
