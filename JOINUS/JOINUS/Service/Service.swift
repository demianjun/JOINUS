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
              makeMatchingModel = MakeMatchingModel.shared
  
  let putOnboardingUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/onboard",
      roomControllerUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/room"
  
  func putMyInfo(completion: @escaping (()->())) {
    
    let param = ["age": self.myInfoModel.myAge,
//                 "firebase_token": "\(self.messagingModel.firebaseToken)",
                 "firebase_token": "testFirebaseToken",
                 "gender": self.myInfoModel.myGender,
//                 "image_address": "\(self.myInfoModel.myProfileImg)",
                 "image_address": "testImgAddress",
                 "nickname": self.myInfoModel.myGameID,
                 "sub": self.myInfoModel.subToken] as [String : Any]
    
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
                
                completion()
              }
              
            } catch(let err) {
              
              print("put result err " + err.localizedDescription)
              
            }
          case .failure(let err):
            print("put my info err " + err.localizedDescription)
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
    
    let parameters: Parameters = ["game_name": "league of legends",//self.makeMatchingModel.selectedGame,
                                  "highest_tier": self.makeMatchingModel.smallestTier,
                                  "lowest_tier": self.makeMatchingModel.largestTier,
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
}
