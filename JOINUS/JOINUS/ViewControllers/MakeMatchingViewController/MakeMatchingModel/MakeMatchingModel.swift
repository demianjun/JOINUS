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
  
  var roomTitle = String(),
      countJoinPeople = 1,
      selectedGame = String(),
      startGameDate = String(),
      isVoiceChat = false,
      lowestTier = 0,
      highestTier = 7
  
  func initialized() {
    self.roomTitle = ""
    self.countJoinPeople = 1
    self.selectedGame = ""
    self.startGameDate = ""
    self.isVoiceChat = Bool()
    self.lowestTier = 0
    self.highestTier = 7
  }
  
}

