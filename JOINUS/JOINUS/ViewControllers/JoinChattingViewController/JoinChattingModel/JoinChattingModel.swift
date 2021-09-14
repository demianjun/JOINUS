//
//  JoinChattingModel.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit

class JoinChattingModel {
  
  static let shared = JoinChattingModel()
  
  var selectedRoomPk = Int(),
      selectedRoomManner = Int()
  
  var getRoomUsers = [GetRoomUser]()
}
