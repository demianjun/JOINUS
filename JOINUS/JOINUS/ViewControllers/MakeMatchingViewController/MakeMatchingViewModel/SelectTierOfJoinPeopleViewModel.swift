//
//  SelectTierOfJoinPeopleViewModel.swift
//  JOINUS
//
//  Created by Demian on 2021/09/12.
//

import UIKit
import RxSwift

class SelectTierOfJoinPeopleViewModel {
  private let tier = TierToString()
  
  // MARK: Model
  private let makeMatchingModel = MakeMatchingModel.shared
  
  // MARK: Input
  let inputSmallestTierRange = BehaviorSubject(value: -1),
      inputLargestTierRange = BehaviorSubject(value: -1)
  
  // MARK: Output
  let outputSmallestPossible = BehaviorSubject(value: true),
      outputlargestPossible = BehaviorSubject(value: true),
      outputTierRange = BehaviorSubject(value: [""]),
      outputSmallestTierRange = BehaviorSubject(value: -1),
      outputLargestTierRange = BehaviorSubject(value: -1)
  
  // MARK: Bind
  func bindSelectTierRagne() {
    _ = Observable.combineLatest(inputSmallestTierRange,
                                 inputLargestTierRange)
      .asObservable()
      .map { self.tier.selectTierRange(lowest: $0.0,
                                       highest: $0.1) }
      .bind(to: self.outputTierRange)
  }
  
  // MARK: Method
}
