//
//  JoinChattingMethods.swift
//  JOINUS
//
//  Created by Demian on 2021/09/17.
//

import UIKit
import RxSwift

extension JoinChattingViewController {
  
  func sendMessage() {
    let textView = self.messageTextView.useInputTextView(),
        placeHolder = self.messageTextView.usePlaceHolderLabel(),
        sendButton = self.messageTextView.useSendButton()
    
    sendButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        var dateComponents = DateComponents()
        
        let calendar = Calendar.current,
            dateformatter = DateFormatter().then {
              $0.dateFormat = "h:mm"
            },
            keyDateformatter = DateFormatter().then {
              $0.dateFormat = "H:mm:ss"
            }
        
        dateComponents.hour = calendar.component(.hour, from: Date())
        dateComponents.minute = calendar.component(.minute, from: Date())
        dateComponents.second = calendar.component(.second, from: Date())
        
        let date = calendar.date(from: dateComponents)!,
            sendTime = calendar.amSymbol.appending(" ").appending(dateformatter.string(from: date)),
            keyTime = keyDateformatter.string(from: date)
        
        if !textView.text.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
          
          if let message = textView.text,
             message.count != 0 {
            
            self.setDBdata(keyTime: keyTime,
                           userPk: self.myInfoModel.myPk,
                           sendTime: sendTime,
                           message: message)
          }
        }
        
        textView.text.removeAll()
        placeHolder.isHidden = textView.hasText
        
        textView.snp.remakeConstraints {
          $0.center.equalToSuperview()
          $0.width.equalToSuperview().multipliedBy(0.9)
          $0.height.equalTo(CommonLength.shared.height(30))
        }
        self.messageTextView.snp.updateConstraints {
          $0.width.centerX.equalToSuperview()
          $0.height.equalTo(CommonLength.shared.height(58))
        }
        
      }).disposed(by: self.bag)
  }
  
  func addDocumentFromChattingRoom(com: (()->())? = nil) {
    
    self.joinusChat?
      .document("\(self.roomInfo!.roomPk)")
      .setData(["join": "채팅방에 참가 하였습니다."])
    
    //    self.joinusChat?
    //      .document("\(self.roomInfo!.roomPk)")
    //      .setData(["join": "채팅방에 참가 하였습니다."])
    com?()
  }
  
  func getMessage() {
    //  var type: JoinChattingModel.chat?
    
    self.listener =
      self.joinusChat?
      .document("\(self.roomInfo!.roomPk)")
      .collection("chat")
      .addSnapshotListener { docuSnapShot, err in
        
        if let err = err {
          
          print("Error fetching document: \(err)")
          return
          
        } else {
          
          guard let snapShot = docuSnapShot else { return print("snapshot return.") }
          self.snapShots = snapShot.documents
          
        }
        
        self.chattingScroll()
      }
    //    self.listener =
    //      self.joinusChat?
    //      .document("\(self.roomInfo!.roomPk)")
    //      .addSnapshotListener { docuSnapShot, err in
    //
    //        if let err = err {
    //
    //          print("Error fetching document: \(err)")
    //          return
    //
    //        } else {
    //
    //          guard let snapShot = docuSnapShot else { return print("snapshot return.") }
    //          guard let data = snapShot.data() else { return print("Document data was empty.") }
    //
    //          data.keys.forEach {
    //
    //            guard var sendTime = data["sendTime"] as? String else { return }
    //            guard var message = data["message"] as? String else { return }
    //
    //            if ($0 != "sendTime"),
    //               ($0 != "message") {
    //
    //              if $0 == "join" {
    //                type = .join
    //
    //                message = ""
    //                sendTime = ""
    //
    //              } else if $0 == "\(self.myInfoModel.myPk)" {
    //                type = .my
    //
    //              } else {
    //                type = .other
    //
    //              }
    //
    //              guard let userPk = data[$0] as? String else { return }
    //              self.joinChattingModel.messages.append([type!: ["\(userPk)", sendTime, message]])
    //            }
    //          }
    //
    //          self.chattingScroll()
    //
    //          print("-> saved message: \(self.joinChattingModel.messages)")
    //        }
    //      }
  }
  
  func setDBdata(keyTime: String,
                 userPk: Int, sendTime: String, message: String) {
    
    self.joinusChat?
      .document("\(self.roomInfo!.roomPk)")
      .collection("chat")
      .document(keyTime)
      .setData(["message": message,
                "time": sendTime,
                "\(self.myInfoModel.myPk)": self.myInfoModel.myGameID])
    
    //    self.joinusChat?
    //      .document("\(self.roomInfo!.roomPk)")
    //      .setData(["\(userPk)": "\(userPk)",
    //                "sendTime": sendTime,
    //                "message": message])
  }
}
