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
  
  let homeListUrl = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/room"
  
  func postMyInfo() {
    
  }
  
  func getHomeListInfo() {
    
    AF.request(self.homeListUrl)
      .validate(statusCode: 150...500)
      .responseJSON { response in
        
        switch response.result {
          
          case .success(let res):
            
            do {
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
              
              
                  let data = try JSONDecoder().decode(RoomInfo.self, from: temp)
              
              
              print(data)
              
            } catch(let err) {
              
              print("get room info err" + err.localizedDescription)
            }
            
          case .failure(let err):
            print("get home list err" + err.localizedDescription)
        }
      }
  }
}
