//
//  MyInfoViewModel.swift
//  JOINUS
//
//  Created by Demian on 2021/09/14.
//

import UIKit
import RxSwift

class MyInfoViewModel {
  // MARK: Model
  let myInfoModel = MyInfoModel.shared
  
  // MARK: Input
  let selectProfileImageInputSubject = PublishSubject<UIImage>(),
      inputEditMyGameID = PublishSubject<String>()
  
  // MARK: Output
  let myProfileImageOutputSubject = BehaviorSubject(value: UIImage(named: "defaultProfile_60x60")),
      outputShowGameID = PublishSubject<String>()
      
  // MARK: Bind
  
  func bindSelectProfileImage() {
    
    _ = self.selectProfileImageInputSubject
      .asObserver()
      .map(saveMyProfileImage(image:))
      .bind(to: self.myProfileImageOutputSubject)
  }
  
  func bindShowGameID() {
    _ = self.inputEditMyGameID
      .asObserver()
      .bind(to: self.outputShowGameID)
  }
  
  // MARK: Methods
  func saveMyProfileImage(image: UIImage) -> UIImage {
    
    self.myInfoModel.myProfileImg = image
    
    return image
  }
}

