//
//  MakeMatchingScrollView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/11.
//

import UIKit

class MakeMatchingScrollView: UIScrollView {
  // MARK: View
  private let inputTitleView = InputTitleView()
  
  private let countJoinPeopleView = CountJoinPeopleView()
  
  private let startDateSetView = StartDateSetView()
  
  private let selectGameView = SelectGameView()
  
  private let selectVoiceChatView = SelectVoiceChatView()
  
  private let setJoinPeopleTierView = SetJoinPeopleTierView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.setupView()
  }
  
  private func setupView() {
    [inputTitleView,
     countJoinPeopleView,
     startDateSetView,
     selectGameView,
     selectVoiceChatView,
     setJoinPeopleTierView].forEach { self.addSubview($0) }
    
    inputTitleView.snp.makeConstraints {
      $0.top.leading.equalToSuperview()
      $0.width.equalToSuperview()
    }
    
    countJoinPeopleView.snp.makeConstraints {
      $0.top.equalTo(inputTitleView.snp.bottom)
      $0.width.centerX.equalToSuperview()
    }
    
    startDateSetView.snp.makeConstraints {
      $0.top.equalTo(countJoinPeopleView.snp.bottom)
      $0.width.centerX.equalToSuperview()
    }
    
    selectGameView.snp.makeConstraints {
      $0.top.equalTo(startDateSetView.snp.bottom)
      $0.width.centerX.equalToSuperview()
    }
    
    selectVoiceChatView.snp.makeConstraints {
      $0.top.equalTo(selectGameView.snp.bottom)
      $0.width.centerX.equalToSuperview()
    }

    setJoinPeopleTierView.snp.makeConstraints {
      $0.top.equalTo(selectVoiceChatView.snp.bottom)
      $0.width.centerX.bottom.equalToSuperview()
    }
  }
  
  func useInputTitleView() -> InputTitleView {
    return self.inputTitleView
  }
  
  func useCountJoinPeopleView() -> CountJoinPeopleView {
    return self.countJoinPeopleView
  }
  
  func useStartDateSetView() -> StartDateSetView {
    return self.startDateSetView
  }
  
  func useSelectGameView() -> SelectGameView {
    return self.selectGameView
  }
  
  func useSelectVoiceChatView() -> SelectVoiceChatView {
    return self.selectVoiceChatView
  }
  
  func useSetJoinPeopleTierView() -> SetJoinPeopleTierView {
    return self.setJoinPeopleTierView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
