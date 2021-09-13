//
//  GameListModel.swift
//  JOINUS
//
//  Created by Demian on 2021/09/07.
//

import UIKit

class HomeListModel {
  
  static let shared = HomeListModel()
  
  var tableView = UITableView()
  
  var gameList = [GetRoomInfo]() {
    didSet {
      self.tableView.reloadData()
    }
  }

  
  let dummy =
    [
      [
        "pk": 1,
        "room_name": "Join Us",
        "game_name": "league of legends",
        "people_number": 3,
        "start_date": "2021-09-03 14:25:00",
        "created_at": "2021-09-01 08:22:56",
        "voice_chat": true,
        "lowest_tier": 2,
        "highest_tier": 6,
        "is_start": 0,
        "now_people_cnt": 2,
        "leader_pk": 1,
        "user_list": [
          [
            "pk": 1,
            "token": "105543436414785658484",
            "firebase_token": nil,
            "gender": 0,
            "age": 29,
            "image_address": nil,
            "nickname": "Faker",
            "login": false
          ],
          [
            "pk": 5,
            "token": "123",
            "firebase_token": "a",
            "gender": 0,
            "age": 21,
            "image_address": "aa",
            "nickname": "Score",
            "login": false
          ]
        ]
      ]
    ]
    
  func test() {
    let temp = try? JSONSerialization.data(withJSONObject: dummy, options: .prettyPrinted)
    let test = try? JSONDecoder().decode([GetRoomInfo].self, from: temp!)
    
    self.gameList = test!
    
  }
  
  init() {
    self.test()
  }
  
}


