//
//  LoginService.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit
import Alamofire
import RxSwift

class LoginService {
  
  static let manager = LoginService()
  
  private let myInfoModel = MyInfoModel.shared,
              messagingModel = MessagingModel.shared,
              homeListModel = HomeListModel.shared,
              makeMatchingModel = MakeMatchingModel.shared,
              myMatchingModel = MyMatchingModel.shared
  
  let loginControllerUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/login/access"
  
  func signUp(accessToken: String, completion: @escaping ((Bool)->())) {
    
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
                  data = try JSONDecoder().decode(GetLogin.self, from: temp)
              
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
              
              completion(data.login)
             
            } catch(let err) {
              
              print(err.localizedDescription + "-> 1")
            }
            
          case .failure(let err):
            
            print(err.localizedDescription + "-> 2")
        }
      }
  }
}

struct GetLogin: Codable {
  
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

