//
//  MyInfoModel.swift
//  JOINUS
//
//  Created by Demian on 2021/09/03.
//

import UIKit

class MyInfoModel {
  
  static let shared = MyInfoModel()
  
  var friendTableView = UITableView(),
      blackListTableView = UITableView()
  
  var getFriend = [GetConnetionData]() {
    didSet {
      self.friendTableView.reloadData()
    }
  }
  
  var getBlackList = [GetConnetionData]() {
    didSet {
      self.blackListTableView.reloadData()
    }
  }
  
  ///tier 0 - iron, 1 - bronze, 2 - silver, 3 - gold, 4 - platinum, 5 - diamond, 6 - master, 7 - challenger
  var myAge = Int(),
      myGender = Int(),
      myGameID = String(), // nick name
      myTier = Int(),
      myProfileImg = UIImage(), // url
      myProfileUrl = String(),
      subToken = String(),
      myPk = Int(),
      gameInfoPk = Int(),
      myGameName = String(),
      myMannerScore = Int()
  
  let administrateList = ["친구목록", "블랙리스트 관리", "구글계정 관리"]
}
