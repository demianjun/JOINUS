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
      selectMyGameInputSubject = PublishSubject<String>(),
      inputGameID = PublishSubject<String>(),
      inputMyTier = PublishSubject<String>(),
      selectProfileImageInputSubject = PublishSubject<UIImage>()
  
  // MARK: Output
  let enableStep2outputSubject = BehaviorSubject(value: false),
      enableStep3outputSubject = BehaviorSubject(value: false),
      enableStep4outputSubject = BehaviorSubject(value: false),
      enableStep5outputSubject = BehaviorSubject(value: false),
      enableProfileVCoutputSubject = BehaviorSubject(value: false),
      myProfileImageOutputSubject = BehaviorSubject(value: UIImage(named: "profile"))
      
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
    
    _ = self.selectMyGameInputSubject
      .asObserver()
      .map(self.checkMyFavoriteGames(game:))
      .bind(to: self.enableStep3outputSubject)   
  }
  
  func bindInputGameID() {
    
    _ = self.inputGameID
      .asObserver()
      .map(self.inputGameID(id:))
      .bind(to: self.enableStep4outputSubject)
  }
  
  func bindInputMyTier() {
    
    _ = self.inputMyTier
      .asObserver()
      .map(self.inputGameID(id:))
      .bind(to: self.enableProfileVCoutputSubject)
  }
  
  func bindSelectProfileImage() {
    
    _ = self.selectProfileImageInputSubject
      .asObserver()
      .bind(to: self.myProfileImageOutputSubject)
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
  
  func checkMyFavoriteGames(game: String) -> Bool {
    
    var result = Bool()
    
    if game.isEmpty {
      
      result = false
      
    } else {
      
      result = true
    }
    
    return result
  }
  
  func inputGameID(id: String) -> Bool {
    
    var result = Bool()
    
    if id.isEmpty {
      
      result = false
      
    } else {
      
      result = true
    }
    
    return result
  }
  
  func inputMyTier(tier: String) -> Bool {
    
    var result = Bool()
    
    if tier.isEmpty {
      
      result = false
      
    } else {
      
      result = true
    }
    
    return result
  }
  
}
