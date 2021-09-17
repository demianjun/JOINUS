//
//  RoomUser.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit
import Alamofire
import RxSwift

class RoomUserService {
  static let manager = RoomUserService()
  
  private let joinChattingModel = JoinChattingModel.shared,
              myInfoModel = MyInfoModel.shared
  
  let roomUserControllerUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/roomuser"
  
  func getRoomUser(completion: @escaping (()->())) {
    let param: Parameters = ["room_pk": self.joinChattingModel.selectedRoomPk]
    
    AF.request(self.roomUserControllerUrl,
               method: .get,
               parameters: param)
      .validate(statusCode: 150...500)
      .responseJSON { response in
        
        switch response.result {
          
          case .success(let res):
            
            do {
              
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
              let data = try JSONDecoder().decode([GetRoomUser].self, from: temp)
              
              self.joinChattingModel.getRoomUsers = data
              completion()
              
            } catch(let err) {
              
              print("-> get room info err  123" + err.localizedDescription)
            }
            
          case .failure(let err):
            print("-> get home list err 234 " + err.localizedDescription)
        }
      }
  }
  
  func postRoomUser(completion: @escaping ((Int)->())) {
    let param: Parameters = ["room_pk": self.joinChattingModel.selectedRoomPk,
                             "user_pk": self.myInfoModel.myPk]
    
    AF.request(self.roomUserControllerUrl,
               method: .post,
               parameters: param)
      .validate(statusCode: 150...500)
      .responseJSON { response in
        
        switch response.result {
          
          case .success(let res):
            
            do {
              
              if let result = res as? Int {
                
                completion(result)
                
              }
            } catch(let err) {
              
              print("-> get room info err  345" + err.localizedDescription)
            }
            
          case .failure(let err):
            print("-> get home list err 456 " + err.localizedDescription)
        }
      }
  }
}

struct GetRoomUser: Codable {
  var joinUserPk: Int,
      subToken: String,
      firebaseToken: String?,
      gender: Int,
      age: Int,
      imageAddress: String,
      nickName: String?,
      login: Bool
  
  enum CodingKeys: String, CodingKey {
    case gender, age, login,
         joinUserPk = "pk",
         subToken = "token",
         firebaseToken = "firebase_token",
         imageAddress = "image_address",
         nickName = "nickname"
  }
}
