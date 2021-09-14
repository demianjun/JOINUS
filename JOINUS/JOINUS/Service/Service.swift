//
//  Service.swift
//  JOINUS
//
//  Created by Demian on 2021/09/03.
//

import UIKit
import Alamofire
import RxSwift

class Service {
  
  static let manager = Service()
  
  private let myInfoModel = MyInfoModel.shared,
              messagingModel = MessagingModel.shared,
              homeListModel = HomeListModel.shared,
              makeMatchingModel = MakeMatchingModel.shared,
              myMatchingModel = MyMatchingModel.shared
  
  let loginControllerUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/login/access",
      putOnboardingUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/onboard",
      gameControllerUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/game",
      roomControllerUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/room"
  
  func signUp(accessToken: String, completion: (()->())? = nil) {
    
    let param: Parameters = ["code": accessToken]
    
    AF.request(self.loginControllerUrl,
               method: .get,
               parameters: param)
      .validate(statusCode: 150..<500)
      .responseJSON {
        
        switch $0.result {
          
          case .success(let res):
            
            do {
              
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted),
                  data = try JSONDecoder().decode(GetUserInfo.self, from: temp)
              
              self.myInfoModel.myAge = data.age
              self.myInfoModel.myGameID = data.nickName ?? "noname"
              self.myInfoModel.myGender = data.gender
              self.myInfoModel.myPk = data.pk
              self.myInfoModel.subToken = data.subToken
              self.myInfoModel.myProfileUrl = data.imageAddress ?? "defaultProfile_60x60"
              
              print("-> age",self.myInfoModel.myAge)
              print("-> gender",self.myInfoModel.myGender)
              print("-> subToken",self.myInfoModel.subToken)
              print("-> profileUrl",self.myInfoModel.myProfileUrl)
              print("-> myPk: \(self.myInfoModel.myPk)")
              
              if !data.login {
            
                completion?()
             
              } else {

                self.getUserGameInfo(myPk: self.myInfoModel.myPk) {
                  
                  let setTabbarController = SetTabbarController()
                  setTabbarController.settingRootViewController()
                  
                }
              }
            } catch(let err) {
              
              print(err.localizedDescription + "-> 1")
            }
            
          case .failure(let err):
            
            print(err.localizedDescription + "-> 2")
        }
      }
  }
  
  func getUserGameInfo(myPk: Int, completion: (()->())? = nil) {
    
    let param: Parameters = ["user_pk": myPk]
    
    AF.request(self.gameControllerUrl,
               method: .get,
               parameters: param)
      .validate(statusCode: 150...500)
      .responseJSON { response in
        
        switch response.result {
          
          case .success(let res):
            
            do {
              
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
              let data = try JSONDecoder().decode([GetUserGameInfo].self, from: temp)
              
              guard !data.isEmpty else { return print("-> get user gameInfo") }
              let userGameInfo = data[0]
              
              self.myInfoModel.myPk = userGameInfo.userPk
              self.myInfoModel.gameInfoPk = userGameInfo.gameInfoPk//pk로 들어옴
              self.myInfoModel.myGameID = userGameInfo.gameID//온보딩에서 작성하는 게임아이디
              self.myInfoModel.myGameName = userGameInfo.gameName
              self.myInfoModel.myTier = userGameInfo.tier
              
              print("-> myPk: \(self.myInfoModel.myPk)")
              print("-> gameID: \(self.myInfoModel.myGameID)")
              print("-> game name: \(self.myInfoModel.myGameName)")
              print("-> myTier: \(self.myInfoModel.myTier)")
              
              if !self.myInfoModel.myGameName.isEmpty {
                
                completion?()
              }
            } catch(let err) {
              
              print("get room info err  " + err.localizedDescription)
            }
            
          case .failure(let err):
            print("get home list err  " + err.localizedDescription)
        }
      }
  }
  
  func putMyInfo(completion: @escaping (()->())) {
    
    let param: Parameters = ["age": self.myInfoModel.myAge,
//                             "firebase_token": "\(self.messagingModel.firebaseToken)",
                             "firebase_token": "testFirebaseToken",
                             "gender": self.myInfoModel.myGender,
//                             "image_address": "\(self.myInfoModel.myProfileImg)",
                             "image_address": "testImgAddress",
                             "nickname": self.myInfoModel.myGameID,
                             "sub": self.myInfoModel.subToken]
    
    AF.request(self.putOnboardingUrl,
               method: .put,
               parameters: param)
      .validate(statusCode: 150...500)
      .responseJSON { response in
       
        switch response.result {
          case .success(let res):
            
            do {
              
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted),
                  data = try JSONDecoder().decode(putUserInfo.self, from: temp)
              print("put data: \(data)")
              if data.status == 200 {
                
                self.postUserGameInfo() {
                
                completion()
                }
              }
            } catch(let err) {
              
              print("put result err " + err.localizedDescription)
              
            }
          case .failure(let err):
            print("put my info err " + err.localizedDescription)
        }
      }
  }
  
  func postUserGameInfo(completion: (()->())? = nil) {
    
    let param: Parameters = ["game_id": self.myInfoModel.myGameID,
                             "name": self.myInfoModel.myGameName,
                             "pk": self.myInfoModel.gameInfoPk,
                             "tier": self.myInfoModel.myTier,
                             "user_pk": self.myInfoModel.myPk]
    
    AF.request(self.gameControllerUrl,
               method: .post,
               parameters: param)
      .validate(statusCode: 150...500)
      .responseJSON { response in
        
        switch response.result {
          
          case .success(let res):
            do {
              
              if let result = res as? Int {
                
                if result == 1 {
                  
                  completion?()
                }
              }
            } catch(let err) {
              
              print(err.localizedDescription + "post roomInfo 1")
            }
            
          case .failure(let err):
            print(err.localizedDescription + "post roomInfo 2")
        }
      }
  }
  
  func putUserGameInfo(completion: (()->())? = nil) {
    
//    let param: Parameters = ["game_id": self.myInfoModel.myGameID,
//                             "name": self.myInfoModel.myGameName,
//                             "pk": self.myInfoModel.gameInfoPk,
//                             "tier": self.myInfoModel.myTier,
//                             "user_pk": self.myInfoModel.myPk]
    
    let param: Parameters = ["game_id": self.myInfoModel.myGameID,
                             "name": "league of legends",
                             "pk": 5,
                             "tier": 2,
                             "user_pk": 2]
    
    AF.request(self.gameControllerUrl,
               method: .put,
               parameters: param,
               encoding: JSONEncoding.prettyPrinted)
      .validate(statusCode: 150...500)
      .responseJSON { response in
        
        switch response.result {
          
          case .success(let res):
            do {
              
              if let result = res as? Int {
                
                if result == 1 {
                  
                  completion?()
                }
              }
            } catch(let err) {
              
              print(err.localizedDescription + "post roomInfo 1")
            }
            
          case .failure(let err):
            print(err.localizedDescription + "post roomInfo 2")
        }
      }
  }
  
  func getHomeListInfo(completion: @escaping (()->())) {
    
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
              
              print("get room info err  " + err.localizedDescription)
            }
            
          case .failure(let err):
            print("get home list err  " + err.localizedDescription)
        }
      }
  }
  
  func postMakeMatchingRoomInfo(completion: @escaping (()->())) {
    
    let parameters: Parameters = ["game_name": self.myInfoModel.myGameName,//self.makeMatchingModel.selectedGame,
                                  "highest_tier": self.makeMatchingModel.lowestTier,
                                  "lowest_tier": self.makeMatchingModel.highestTier,
                                  "people_number": self.makeMatchingModel.countJoinPeople,
                                  "room_name": self.makeMatchingModel.roomTitle,
                                  "start_date": self.makeMatchingModel.startGameDate,
                                  "user_pk": self.myInfoModel.myPk,
                                  "voice_chat": self.makeMatchingModel.isVoiceChat] as [String: Any]
    
    let headers: HTTPHeaders = [
      "connection": "keep-alive ",
      "Content-Type": "application/json "
    ]
    
    AF.request(self.roomControllerUrl,
               method: .post,
               parameters: parameters,
               encoding: JSONEncoding.prettyPrinted,
               headers: headers)
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
  
  func getJoinedMatching(completion: @escaping (()->())) {
//    self.myInfoModel.subToken = "109112693255361562533"
    
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
              
              print("get room info err  " + err.localizedDescription)
            }
            
          case .failure(let err):
            print("get home list err  " + err.localizedDescription)
        }
      }
  }
  
  func getMadeMatching(completion: @escaping (()->())) {
    
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
              
              print("get room info err  " + err.localizedDescription)
            }
            
          case .failure(let err):
            print("get home list err  " + err.localizedDescription)
        }
      }
  }
}
