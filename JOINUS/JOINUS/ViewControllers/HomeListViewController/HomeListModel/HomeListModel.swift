//
//  GameListModel.swift
//  JOINUS
//
//  Created by Demian on 2021/09/07.
//

import Foundation

class HomeListModel {
  
  static let shared = HomeListModel()
  
  
}

struct RoomInfo: Codable {
  var roomInfos: [RoomInfos]
}

struct RoomInfos: Codable {
  var pk: Int,
      roomName: String,
      gameName: String,
      peopleNumber: Int,
      startDate: String,
      createdAt: String,
      voiceChat: Bool,
      lowestTier: Int,
      highestTier: Int,
      isStart: Int,
      nowPeopleCnt: Int,
      leaderPk: Int,
      userList: JoinUserInfos
  
  enum CodingKeys: String, CodingKey {
    case pk,
         roomName = "room_name",
         gameName = "game_name",
         peopleNumber = "people_number",
         startDate = "start_date",
         createdAt = "created_at",
         voiceChat = "voice_chat",
         lowestTier = "lowest_tier",
         highestTier = "highest_tier",
         isStart = "is_start",
         nowPeopleCnt = "now_people_cnt",
         leaderPk = "leader_pk",
         userList = "user_list"
  }
}

struct JoinUserInfos: Codable {
  var joinUserInfos: [joinUserInfos]
}

struct joinUserInfos: Codable {
  
  var pk: Int,
      token: String,
      firebaseToken: String?,
      gender: Int,
      age: Int,
      imageAddress: String?,
      nickName: String?,
      login: Bool
  
  enum CodingKeys: String, CodingKey {
    case pk,
         token,
         gender,
         age,
         login,
         firebaseToken = "firebase_token",
         imageAddress = "image_address",
         nickName = "nickname"
  }
}
