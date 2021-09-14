//
//  FriendService.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit
import Alamofire
import RxSwift

class ConnectionService {
  
  static let manager = ConnectionService()
  
  private let myInfoModel = MyInfoModel.shared,
              messagingModel = MessagingModel.shared,
              homeListModel = HomeListModel.shared,
              makeMatchingModel = MakeMatchingModel.shared,
              myMatchingModel = MyMatchingModel.shared
  
  let connetionUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/connection"
  
  func getConnection(isFriend: Bool, completion: @escaping (()->())) {
    
    let param: Parameters = ["start_id": self.myInfoModel.myPk,
                             "friend_or_black": isFriend]
    
    AF.request(self.connetionUrl,
               method: .get,
               parameters: param)
      .validate(statusCode: 150...500)
      .responseJSON { response in
        
        switch response.result {
          
          case .success(let res):
            
            do {
              
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
              let data = try JSONDecoder().decode(GetConnetion.self, from: temp)
              
              if data.count == 1 {
                
                if isFriend {
                  
                  self.myInfoModel.getFriend = data.data
                  
                } else {
                  
                  self.myInfoModel.getBlackList = data.data
                }
                completion()
              }
              
            } catch(let err) {
              completion()
              print("get connection info err  " + err.localizedDescription)
            }
            
          case .failure(let err):
            print("get connection list err  " + err.localizedDescription)
        }
      }
  }
  
  func postConnetion(isFriend: Bool, completion: (()->())? = nil) {
    
    let param: Parameters = ["end_id": 7,//친구추가를 당하는 사람
                             "friend_or_black": isFriend,
                             "pk": 0,
                             "start_id": self.myInfoModel.myPk]//친구추가를 하는 사람
    
    AF.request(self.connetionUrl,
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
              
              print(err.localizedDescription + "post connection 1")
            }
            
          case .failure(let err):
            print(err.localizedDescription + "post connection 2")
        }
      }
  }
}

struct GetConnetion: Codable {
  var errorMessage = String(),
      count = Int(),
      data = [GetConnetionData]()
  
  enum CodingKeys: String, CodingKey {
    case count, data
  }
}

struct GetConnetionData: Codable {
  var connectionPk = Int(),// 친구추가 당한 사람
      gender = Int(),
      age = Int(),
      subToken = String(),
      firebaseToken = String(),
      imageAddress = String(),
      nickName = String(),
      login = Bool()
  
  enum CodingKeys: String, CodingKey {
    case gender, age, login,
         connectionPk = "pk",
         subToken = "token",
         firebaseToken = "firebase_token",
         imageAddress = "image_address",
         nickName = "nickname"
  }
}
