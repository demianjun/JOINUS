//
//  SelectTierOfJoinPeopleViewModel.swift
//  JOINUS
//
//  Created by Demian on 2021/09/12.
//

import UIKit
import RxSwift

class SelectTierOfJoinPeopleViewModel {
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
      .map { range in
        
        self.selectTierRange(smallest: range.0,
                             largest: range.1) }
      .bind(to: self.outputTierRange)
  }
  
  
  // MARK: Method
  
  func selectTierRange(smallest: Int, largest: Int) -> [String] {
    var smallestTier = String(),
        largestTier = String(),
        tierRange = [String]()
    
      if smallest == 0 { // 아이언 이상
        
        smallestTier = "아이언 이상"
        
      } else if smallest == 1 {
        
        smallestTier = "브론즈 이상"
        
      } else if smallest == 2 {
        
        smallestTier = "실버 이상"
        
      } else if smallest == 3 {
        
        smallestTier = "골드 이상"
        
      } else if smallest == 4 {
        
        smallestTier = "플래티넘 이상"
        
      } else if smallest == 5 {
        
        smallestTier = "다이아 이상"
        
      } else if smallest == 6 {
        
        smallestTier = "마스터 이상"
        
      } else if smallest == 7 {
        
        smallestTier = "챌린저 이상"
        
      } else if smallest == -1 {
        
        smallestTier = "모두 가능"// 모두 가능
        
      }
      
      if largest == 0 { // 아이언 이하
        
        largestTier = "아이언 이하"
        
      } else if largest == 1 {
        
        largestTier = "브론즈 이하"
        
      } else if largest == 2 {
        
        largestTier = "실버 이하"
        
      } else if largest == 3 {
        
        largestTier = "골드 이하"
        
      } else if largest == 4 {
        
        largestTier = "플래티넘 이하"
        
      } else if largest == 5 {
        
        largestTier = "다이아 이하"
        
      } else if largest == 6 {
        
        largestTier = "마스터 이하"
        
      } else if largest == 7 {
        
        largestTier = "챌린저 이하"
        
      } else if largest == -1 {
        
        largestTier = "모두 가능"// 모두 가능
        
      }
      
      tierRange.insert(smallestTier,
                       at: 0)
      tierRange.insert(largestTier,
                       at: 1)
      
    if smallest == -1, largest != -1 {
      
      tierRange.remove(at: 0)
      
    } else if smallest != -1, largest == -1 {
      
      tierRange.remove(at: 1)
      
    } else if smallest > largest {
      
      tierRange = ["모두 가능"]
      
    } else if smallest == -1, largest == -1 {
      
      tierRange = ["모두 가능"]
      
    }
    
    return tierRange
  }
}
