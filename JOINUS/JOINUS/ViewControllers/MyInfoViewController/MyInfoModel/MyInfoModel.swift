//
//  MyInfoModel.swift
//  JOINUS
//
//  Created by Demian on 2021/09/03.
//

import UIKit

class MyInfoModel {
  
  static let shared = MyInfoModel()
  
  ///tier 0 - iron, 1 - bronze, 2 - silver, 3 - gold, 4 - platinum, 5 - diamond, 6 - master, 7 - challenger
  var myAge = Int(),
      myGender = Int(),
      myGameID = String(), // nick name
      myTier = Int(),
      myProfileImg = UIImage(), // url
      subToken = String()
}
