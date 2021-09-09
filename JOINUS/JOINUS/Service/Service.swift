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
              homeListModel = HomeListModel.shared
  
  let putOnboardingUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/onboard",
      homeListUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/room"
  
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
    
    AF.request(self.homeListUrl)
      .validate(statusCode: 150...500)
      .responseJSON { response in
        
        switch response.result {
          
          case .success(let res):
            
            do {
              
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
              let data = try JSONDecoder().decode([RoomInfo].self, from: temp)
              
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
}
