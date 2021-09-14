//
//  GameService.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit
import Alamofire
import RxSwift

class GameService {
  
  static let manager = GameService()
  
  private let myInfoModel = MyInfoModel.shared,
              messagingModel = MessagingModel.shared,
              homeListModel = HomeListModel.shared,
              makeMatchingModel = MakeMatchingModel.shared,
              myMatchingModel = MyMatchingModel.shared
  
  let gameControllerUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/game"

  func getGame(completion: @escaping (()->())) {
    
    let param: Parameters = ["user_pk": self.myInfoModel.myPk]
    
    AF.request(self.gameControllerUrl,
               method: .get,
               parameters: param)
      .validate(statusCode: 150...500)
      .responseJSON { response in
        
        switch response.result {
          
          case .success(let res):
            
            do {
              
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
              let data = try JSONDecoder().decode([GetGame].self, from: temp)
              
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
                
                completion()
              }
            } catch(let err) {
              
              print("get room info err  " + err.localizedDescription)
            }
            
          case .failure(let err):
            print("get home list err  " + err.localizedDescription)
        }
      }
  }
  
  func postGame(completion: (()->())? = nil) {
    
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
  
  func putGame(completion: (()->())? = nil) {
    
    let param: Parameters = ["game_id": self.myInfoModel.myGameID,
                             "name": self.myInfoModel.myGameName,
                             "pk": self.myInfoModel.gameInfoPk,
                             "tier": self.myInfoModel.myTier,
                             "user_pk": self.myInfoModel.myPk]
    
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
  
  func deleteGame(completion: (()->())? = nil) {
    
    let param: Parameters = ["game_pk" : self.myInfoModel.myPk]
    
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
}

struct GetGame: Codable {
  var gameInfoPk = Int(),
      userPk = Int(),
      gameName = String(),
      gameID = String(),
      tier = Int()
  
  enum CodingKeys: String, CodingKey {
    case tier,
         gameInfoPk = "pk", userPk = "user_pk",
         gameID = "game_id", gameName = "name"
  }
}
