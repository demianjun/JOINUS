//
//  MannerService.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit
import Alamofire
import RxSwift

class MannerService {
  
  static let manager = MannerService()
  
  private let myInfoModel = MyInfoModel.shared,
              messagingModel = MessagingModel.shared,
              homeListModel = HomeListModel.shared,
              makeMatchingModel = MakeMatchingModel.shared,
              myMatchingModel = MyMatchingModel.shared
  
  let mannerControllerUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/manner"
  
  func getManner(completion: (()->())? = nil) {
    
    let param: Parameters = ["target_pk": self.myInfoModel.myPk]
    
    AF.request(self.mannerControllerUrl,
               method: .get,
               parameters: param)
      .validate(statusCode: 150..<500)
      .responseJSON {
        
        switch $0.result {
          
          case .success(let res):
            
            do {
              
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted),
                  data = try JSONDecoder().decode(GetManner.self, from: temp)
              
             
            } catch(let err) {
              
              print(err.localizedDescription + "-> 1")
            }
            
          case .failure(let err):
            
            print(err.localizedDescription + "-> 2")
        }
      }
  }
  
  func postManner(isGood: Bool, other user: Int, completion: (()->())? = nil) {
    
    //0: bad, 1: good
    var manner = Int()
    
    if isGood {
      manner = 1
    } else {
      manner = 0
    }
    
    let param: Parameters = ["manner": manner,
                             "pk": 0,
                             "target_pk": user,//상대방
                             "user_pk": self.myInfoModel.myPk]//나
    
    AF.request(self.mannerControllerUrl,
               method: .post,
               parameters: param)
      .validate(statusCode: 150..<500)
      .responseJSON {
        
        switch $0.result {
          
          case .success(let res):
            
            do {
              
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted),
                  data = try JSONDecoder().decode(PostManner.self, from: temp)
              
             
            } catch(let err) {
              
              print(err.localizedDescription + "-> 1")
            }
            
          case .failure(let err):
            
            print(err.localizedDescription + "-> 2")
        }
      }
  }
}

struct GetManner: Codable {
  var count = Int(),
      mannerScore = Int()
  
  enum CodingKeys: String, CodingKey {
    case count, mannerScore = "data"
  }
}

struct PostManner: Codable {
  var status = Int(),
      message = String()
  
  enum CodingKeys: String, CodingKey {
    case status, message
  }
}

