//
//  OnboardingViewModel.swift
//  JOINUS
//
//  Created by Demian on 2021/08/31.
//

import Foundation
import RxSwift

class OnboardingViewModel {
  
  // MARK: Input
  let selectGenderInputSubject = PublishSubject<Int>(),
      selectAgeInputSubject = PublishSubject<Int>(),
      selectMyGamesInputSubject = PublishSubject<[String]>()
  
  // MARK: Output
  let enableStep2outputSubject = BehaviorSubject(value: false),
      enalbeStep3outputSubject = BehaviorSubject(value: false),
      enalbeStep4outputSubject = BehaviorSubject(value: false),
      enalbeStep5outputSubject = BehaviorSubject(value: false)
  
  // MARK: Bind
  
  func bindCheckNextStep() {
    
    _ = Observable
      .combineLatest(self.selectGenderInputSubject,
                     self.selectAgeInputSubject)
      .asObservable()
      .map { self.setNextButtonStatus(gender: $0, age: $1) }
      .bind(to: self.enableStep2outputSubject)
  }
  
  func bindCheckMyGame() {
    
    _ = self.selectMyGamesInputSubject
      .asObserver()
      .map(self.checkMyFavoriteGames(games:))
      .bind(to: self.enalbeStep3outputSubject)   
  }
  
  // MARK: Method
  func setNextButtonStatus(gender: Int, age: Int) -> Bool {
    var result = Bool()
    print("gender: \(gender), age: \(age)")
    if age != 0 {
      
      if (gender == 0) || (gender == 1) {
        
        result = true
        
      } else  {
        
        result = false
      }
    } else {
      
      result = false
    }
    
    return result
  }
  
  func checkMyFavoriteGames(games: [String]) -> Bool {
    
    var result = Bool()
    
    if games.count != 0 {
      
      result = true
      
    } else {
      
      result = false
    }
    
    return result
  }
}
