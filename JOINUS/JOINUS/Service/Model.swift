//
//  Model.swift
//  JOINUS
//
//  Created by Demian on 2021/09/08.
//

import Foundation

class MessagingModel {
  static let shared = MessagingModel()
  
  var firebaseToken = String()
}

struct messaging: Codable {
  var firebaseToken: String
  
  enum CodingKeys: String, CodingKey {
    case firebaseToken
  }
}

struct GetUserInfo: Codable {
  
  var age: Int,
      gender: Int,
      pk: Int,
      firebaseToken: String?,
      imageAddress: String?,
      nickName: String?,
      subToken: String,
      login: Bool
  
  enum CodingKeys: String, CodingKey {
    case age, gender, pk, login
    case subToken = "token", firebaseToken = "firebase_token", imageAddress = "image_address", nickName = "nickname"
  }
}

struct putUserInfo: Codable {
  
  var status: Int,
      message: String
  
  enum CodingKeys: String, CodingKey {
    case status, message
  }
}

struct GetRoomInfo: Codable {
  var roomPk: Int,
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
      userList: [JoinUserInfo]
  
  enum CodingKeys: String, CodingKey {
    case roomPk = "pk",
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

struct JoinUserInfo: Codable {
  
  var pk: Int,
      age: Int,
      gender: Int,
      token: String,
      firebaseToken: String?,
      imageAddress: String?,
      nickName: String,
      login: Bool
  
  enum CodingKeys: String, CodingKey {
    case pk = "pk",
         age = "age",
         gender = "gender",
         token = "token",
         firebaseToken = "firebase_token",
         imageAddress = "image_address",
         nickName = "nickname",
         login = "login"
  }
}

struct MakeRoom: Codable {
  var result: Int

  enum CodingKeys: String, CodingKey {
    case result = " "
  }
}
