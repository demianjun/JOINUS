//
//  JoinChattingModel.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit

class JoinChattingModel {
  enum chat {
    case my, other
  }
  
  static let shared = JoinChattingModel()
  
  var joinPeople = Int(),
      selectedRoomPk = Int(),
      selectedRoomManner = Int()
  
  var getSelectedRoom: GetRoomInfo?,
      getRoomUsers = [GetRoomUser]()
  
  var chattingTableView = UITableView()
  
  var messages = [[chat: [String]]]() {
    didSet {
      self.chattingTableView.reloadData()
    }
  }
}
