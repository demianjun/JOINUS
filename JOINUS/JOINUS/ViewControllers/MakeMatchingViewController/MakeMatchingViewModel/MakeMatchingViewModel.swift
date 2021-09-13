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
  let inputCountUpJoinPeople = PublishSubject<MakeMatchingModel.countType>()
  
  // MARK: Output
  let outputCountJoinPeople = BehaviorSubject(value: "1")
  
  // MARK: Bind
  func bindCountJoinPeople() {
    _ = self.inputCountUpJoinPeople
      .asObserver()
      .map(countJoinPeople(_:))
      .bind(to: self.outputCountJoinPeople)
  }
  
  // MARK: Method
  func countJoinPeople(_ type: MakeMatchingModel.countType) -> String {
    
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
  
}
