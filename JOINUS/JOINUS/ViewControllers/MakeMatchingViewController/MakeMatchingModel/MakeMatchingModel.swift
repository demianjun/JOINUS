//
//  MakeMatchingModel.swift
//  JOINUS
//
//  Created by Demian on 2021/09/12.
//

import UIKit

class MakeMatchingModel {
  enum countType {
    case up, down
  }
  
  static let shared = MakeMatchingModel()
  
  var countJoinPeople = 1,
      startGameDate = String(),
      selectedGame = String(),
      isVoiceChat = Bool(),
      smallestTier = Int(),
      largestTier = Int()
  
}
