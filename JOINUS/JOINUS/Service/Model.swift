//
//  Model.swift
//  JOINUS
//
//  Created by Demian on 2021/09/08.
//

import Foundation

class MessagingModel {
  static let shared = MessagingModel()
  
  var firebaseToken = String()
}

struct messaging: Codable {
  var firebaseToken: String
  
  enum CodingKeys: String, CodingKey {
    case firebaseToken
  }
}

