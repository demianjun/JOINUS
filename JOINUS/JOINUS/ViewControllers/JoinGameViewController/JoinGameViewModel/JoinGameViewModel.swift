//
//  JoinGameViewModel.swift
//  JOINUS
//
//  Created by Demian on 2021/09/09.
//

import UIKit
import RxSwift

class JoinGameViewModel {
  
  // MARK: Input
  let inputRoomInfo = PublishSubject<RoomInfo>()
  
  // MARK: Output
  let outputRoomInfo = PublishSubject<RoomInfo>()
  
  // MARK: Bind
  func bindHandOverRoomInfo() {
    
    _ = self.inputRoomInfo
      .asObserver()
      .bind(to: self.outputRoomInfo)
  }
  
  // MARK: Method
  
}
