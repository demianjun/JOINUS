//
//  MyMatchingModel.swift
//  JOINUS
//
//  Created by Demian on 2021/09/14.
//

import UIKit

class MyMatchingModel {
  
  static let shared = MyMatchingModel()
  
  var myMatchingTableView = UITableView()
  
  var matchingList = [GetRoomInfo]() {
    didSet {
      self.myMatchingTableView.reloadData()
    }
  }
}
