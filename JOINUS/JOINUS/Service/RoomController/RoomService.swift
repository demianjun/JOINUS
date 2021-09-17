//
//  RoomService.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit
import Alamofire
import RxSwift

class RoomService {
  
  static let manager = RoomService()
  
  private let myInfoModel = MyInfoModel.shared,
              messagingModel = MessagingModel.shared,
              homeListModel = HomeListModel.shared,
              makeMatchingModel = MakeMatchingModel.shared,
              myMatchingModel = MyMatchingModel.shared,
              joinChattingModel = JoinChattingModel.shared
  
  let roomControllerUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/room"
  
  func getRoom(completion: @escaping (()->())) {
    
    AF.request(self.roomControllerUrl)
      .validate(statusCode: 150...500)
      .responseJSON { response in
        
        switch response.result {
          
          case .success(let res):
            
            do {
              
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
              let data = try JSONDecoder().decode([GetRoomInfo].self, from: temp)
              
              self.homeListModel.gameList = data
              completion()
              
            } catch(let err) {
              
              print("get room info err  11" + err.localizedDescription)
            }
            
          case .failure(let err):
            print("get home list err  22" + err.localizedDescription)
        }
      }
  }
  
  func postRoom(completion: @escaping (()->())) {
    
    let parameters: Parameters = ["game_name": "league of legends",//self.myInfoModel.myGameName,//self.makeMatchingModel.selectedGame,
                                  "highest_tier": self.makeMatchingModel.lowestTier,
                                  "lowest_tier": self.makeMatchingModel.highestTier,
                                  "people_number": self.makeMatchingModel.countJoinPeople,
                                  "room_name": self.makeMatchingModel.roomTitle,
                                  "start_date": self.makeMatchingModel.startGameDate,
                                  "user_pk": self.myInfoModel.myPk,
                                  "voice_chat": self.makeMatchingModel.isVoiceChat]
    
    AF.request(self.roomControllerUrl,
               method: .post,
               parameters: parameters,
               encoding: JSONEncoding.prettyPrinted)
      .validate(statusCode: 150...500)
      .responseJSON { response in
        
        switch response.result {
          
          case .success(let res):
            do {
              
              if let roomPk = res as? Int {
                
                completion()
                
              }
            } catch(let err) {
              
              print(err.localizedDescription + "post roomInfo 1")
            }
            
          case .failure(let err):
            print(err.localizedDescription + "post roomInfo 2")
        }
      }
  }
  
  func getJoinRoom(completion: @escaping (()->())) {
    
    AF.request(self.roomControllerUrl
                .appending("/user/")
                .appending(self.myInfoModel.subToken)
                .appending("/0"))
      .validate(statusCode: 150...500)
      .responseJSON { response in
        
        switch response.result {
          
          case .success(let res):
            
            do {
              
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
              let data = try JSONDecoder().decode([GetRoomInfo].self, from: temp)
              
              self.myMatchingModel.matchingList = data

              completion()
              
            } catch(let err) {
              
              print("get room info err 33 " + err.localizedDescription)
            }
            
          case .failure(let err):
            print("get home list err  44" + err.localizedDescription)
        }
      }
  }
  
  func getMakeRoom(completion: @escaping (()->())) {
    
    AF.request(self.roomControllerUrl
                .appending("/user/")
                .appending(self.myInfoModel.subToken)
                .appending("/1"))
      .validate(statusCode: 150...500)
      .responseJSON { response in
        
        switch response.result {
          
          case .success(let res):
            
            do {
              
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
              let data = try JSONDecoder().decode([GetRoomInfo].self, from: temp)
                
              self.myMatchingModel.matchingList = data

              completion()
              
            } catch(let err) {
              
              print("get room info err 55 " + err.localizedDescription)
            }
            
          case .failure(let err):
            print("get home list err  66" + err.localizedDescription)
        }
      }
  }
  
  func getSelectedRoom(completion: @escaping (()->())) {
    
    AF.request(self.roomControllerUrl
                .appending("/")
                .appending("\(self.joinChattingModel.selectedRoomPk)"))
      .validate(statusCode: 150...500)
      .responseJSON { response in
        
        switch response.result {
          
          case .success(let res):
            
            do {
              
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
              let data = try JSONDecoder().decode(GetRoomInfo.self, from: temp)
                
              self.joinChattingModel.getSelectedRoom = data

              completion()
              
            } catch(let err) {
              
              print("get room info err 77 " + err.localizedDescription)
            }
            
          case .failure(let err):
            print("get home list err  88" + err.localizedDescription)
        }
      }
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
      roomManner: Int,
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
         roomManner = "room_manner",
         userList = "user_list"
  }
}

struct JoinUserInfo: Codable {
  
  var joinUserPk: Int,
      age: Int,
      gender: Int,
      token: String,
      firebaseToken: String?,
      imageAddress: String,
      nickName: String,
      login: Bool
  
  enum CodingKeys: String, CodingKey {
    case joinUserPk = "pk",
         age = "age",
         gender = "gender",
         token = "token",
         firebaseToken = "firebase_token",
         imageAddress = "image_address",
         nickName = "nickname",
         login = "login"
  }
}
