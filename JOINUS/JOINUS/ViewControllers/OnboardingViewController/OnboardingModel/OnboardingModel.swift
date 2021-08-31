//
//  OnboardingModel.swift
//  JOINUS
//
//  Created by Demian on 2021/08/31.
//

import Foundation

class OnboardingModel {
  static let shared = OnboardingModel()
  
  enum myGame: String {
    case lol, sudden, overWatch, battleGround, mapleStory
  }
  
  var ages: [String] {
    var temp = [String]()
    
    for i in 20...70 {
      temp.append(String(i).appending("세"))
    }
    
    return temp
  }
  
  var myAge = Int(),
      myGender = Int(),
      myGameID = String()
      
}
