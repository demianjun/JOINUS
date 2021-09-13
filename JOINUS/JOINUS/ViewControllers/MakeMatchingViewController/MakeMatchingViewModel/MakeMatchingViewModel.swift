//
//  MakeMatchingViewModel.swift
//  JOINUS
//
//  Created by Demian on 2021/09/12.
//

import UIKit
import RxSwift

class MakeMatchingViewModel {
  // MARK: Model
  private let makeMatchingModel = MakeMatchingModel.shared
  
  // MARK: Input
  let inputCountUpJoinPeople = PublishSubject<MakeMatchingModel.countType>(),
      inputGameStartDate = BehaviorSubject(value: Date())
  
  // MARK: Output
  let outputCountJoinPeople = BehaviorSubject(value: "1"),
      outputSetGameStartDate = BehaviorSubject(value: "")
  
  // MARK: Bind
  func bindCountJoinPeople() {
    _ = self.inputCountUpJoinPeople
      .asObserver()
      .map(countJoinPeople(_:))
      .bind(to: self.outputCountJoinPeople)
  }
  
  func bindSetGameStartDate() {
    _ = self.inputGameStartDate
      .asObserver()
      .map(startDateToString(_:))
      .bind(to: self.outputSetGameStartDate)
  }
  
  // MARK: Method
  private func countJoinPeople(_ type: MakeMatchingModel.countType) -> String {
    
    switch type {
      case .up:
        
        if self.makeMatchingModel.countJoinPeople >= 4 {
          
          self.makeMatchingModel.countJoinPeople = 4
          
        } else {
          
          self.makeMatchingModel.countJoinPeople += 1
        }
        
      case .down:
        
        if self.makeMatchingModel.countJoinPeople <= 1 {
          
          self.makeMatchingModel.countJoinPeople = 1
        } else {
          
          self.makeMatchingModel.countJoinPeople -= 1
        }
    }
    
    return String(self.makeMatchingModel.countJoinPeople)
  }
  
  private func startDateToString(_ date: Date) -> String {
    let dateFormatter = DateFormatter().then {
      $0.locale = Locale(identifier: "Ko_kr")
      $0.dateFormat = "yyyy년 M월 dd일"
    }
    var setDate = String()
    
    setDate = dateFormatter.string(from: date)
    
    return setDate
  }
}
