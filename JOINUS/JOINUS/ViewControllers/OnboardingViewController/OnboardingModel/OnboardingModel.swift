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
  
  enum myTier: String {
    case iron = "아이언",
         bronze = "브론즈",
         silver = "실버",
         gold = "골드",
         platinum = "플래티넘",
         diamond = "다이아",
         master = "마스터",
         challenger = "챌린저"
  }
  
  var ages: [String] {
    var temp = [String]()
    
    for i in 20...70 {
      temp.append(String(i).appending("세"))
    }
    
    return temp
  }
}
