//
//  OnboardingService.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit
import Alamofire
import RxSwift

class OnboardingService {
  
  static let manager = OnboardingService()
  
  private let myInfoModel = MyInfoModel.shared,
              messagingModel = MessagingModel.shared,
              homeListModel = HomeListModel.shared,
              makeMatchingModel = MakeMatchingModel.shared,
              myMatchingModel = MyMatchingModel.shared
  
  let onboardingUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/onboard"
 
  func putOnboarding(completion: @escaping (()->())) {
    
    let param: Parameters = ["age": self.myInfoModel.myAge,
//                             "firebase_token": "\(self.messagingModel.firebaseToken)",
                             "firebase_token": "testFirebaseToken",
                             "gender": self.myInfoModel.myGender,
//                             "image_address": "\(self.myInfoModel.myProfileImg)",
                             "image_address": "testImgAddress",
                             "nickname": self.myInfoModel.myGameID,
                             "sub": self.myInfoModel.subToken]
    
    AF.request(self.onboardingUrl,
               method: .put,
               parameters: param)
      .validate(statusCode: 150...500)
      .responseJSON { response in
       
        switch response.result {
          case .success(let res):
            
            do {
              
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted),
                  data = try JSONDecoder().decode(PutOnboarding.self, from: temp)
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
}

struct PutOnboarding: Codable {
  
  var status: Int,
      message: String
  
  enum CodingKeys: String, CodingKey {
    case status, message
  }
}

