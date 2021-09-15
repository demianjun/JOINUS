//
//  JointChattingViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit
import RxSwift
import SwiftSocket

class JoinChattingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
  
  private let bag = DisposeBag()
  
  public var roomInfo: GetRoomInfo?
  
  private var keyboradObservable: Observable<CGFloat>?
  
  private let tapGesture = UITapGestureRecognizer()
  
  // MARK: Model
  private let joinChattingModel = JoinChattingModel.shared
  private let myInfoModel = MyInfoModel.shared
  
  // MARK: View
  private let navigationView = CustomNavigationView()
  
  private let triColonRightButtonItem = UIButton().then {
    $0.setImage(UIImage(named: "tricolon"),
                for: .normal)
  }
  
  private let peopleRightButtonItem = UIButton().then {
    $0.setImage(UIImage(named: "people"),
                for: .normal)
  }
  
  private let leftButtonItem = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"),
                for: .normal)
    $0.tintColor = .black
    $0.transform = .init(scaleX: 1.5, y: 1.5)
  }
  
  private let centerButtonItem = UIButton().then {
    $0.adjustsImageWhenHighlighted = false
  }
  
  private let naviBarTitleLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 19)
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  private let chattingTableView = UITableView().then {
    $0.backgroundColor = .white
    $0.separatorStyle = .none
  }
  
  private let messageTextView = MessageTextView()
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.messageTextView.useInputTextView().delegate = self
    self.chattingTableView.delegate = self
    self.chattingTableView.dataSource = self
    self.joinChattingModel.chattingTableView = self.chattingTableView
    self.chattingTableView.register(ChattingTableViewCell.self,
                                    forCellReuseIdentifier: ChattingTableViewCell.ID)
    self.setupView()
    self.setRoomMannerImage()
    self.setNavigationBar()
    self.popViewController()
    self.didTapCenterButtonItem()
    self.keyboardObserv()
    self.shiftTextView()
    self.sendMessage()
    self.textViewPlaceHolder()
    self.setTapGestureAction()
  }
  
  private func setupView() {
    [navigationView, chattingTableView, messageTextView].forEach { self.view.addSubview($0) }
    
    navigationView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(100))
    }
    
    chattingTableView.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom)
      $0.width.centerX.bottom.equalToSuperview()
    }
    
    messageTextView.snp.makeConstraints {
      $0.width.centerX.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(CommonLength.shared.height(58))
    }
    
    self.view.addGestureRecognizer(self.tapGesture)
  }
  
  private func setNavigationBar() {
    [leftButtonItem,
     naviBarTitleLabel, centerButtonItem,
     triColonRightButtonItem, peopleRightButtonItem].forEach { self.navigationView.addSubview($0) }
    
    naviBarTitleLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(20))
      $0.centerX.equalToSuperview()
    }
    
    leftButtonItem.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
      $0.centerY.equalTo(naviBarTitleLabel)
      $0.width.height.equalTo(CommonLength.shared.width(15))
    }
    
    centerButtonItem.snp.makeConstraints {
      $0.width.height.equalTo(CommonLength.shared.width(26))
      $0.centerY.equalTo(naviBarTitleLabel)
      $0.trailing.equalTo(naviBarTitleLabel.snp.leading).offset(-CommonLength.shared.width(12))
    }
    
    triColonRightButtonItem.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(17))
      $0.centerY.equalTo(naviBarTitleLabel)
      $0.width.equalTo(CommonLength.shared.width(20))
      $0.height.equalTo(CommonLength.shared.height(20))
    }
    
    peopleRightButtonItem.snp.makeConstraints {
      $0.trailing.equalTo(triColonRightButtonItem.snp.leading).offset(-CommonLength.shared.width(10))
      $0.centerY.equalTo(naviBarTitleLabel)
      $0.width.equalTo(CommonLength.shared.width(30))
      $0.height.equalTo(CommonLength.shared.height(35))
    }
    
    self.naviBarTitleLabel.text = self.roomInfo?.roomName
    
    self.navigationController?.navigationBar.isHidden = true
  }
  
  func textViewDidChange(_ textView: UITextView) {
    let size = CGSize(width: CommonLength.shared.width(375) * 0.9,
                      height: .infinity),
      estimateSize = textView.sizeThatFits(size)
    
    textView.constraints.forEach {
      if $0.firstAttribute == .height {
        $0.constant = estimateSize.height
      }
    }
    
    self.messageTextView.constraints.forEach {
      if $0.firstAttribute == .height {
        $0.constant = estimateSize.height + CommonLength.shared.height(30)
      }
    }
  }
  
  private func setRoomMannerImage() {
    var named = String()
    
    let roomMannerScore = self.joinChattingModel.selectedRoomManner
    
    if roomMannerScore >= -5 {
      
      named = "manner1_24x24"
      
    } else if roomMannerScore < 1 {
      
      named = "manner2_24x24"
      
    } else if roomMannerScore < 6 {
      
      named = "manner3_24x24"
      
    } else if roomMannerScore >= 6 {
      
      named = "manner4_24x24"
    }
    
    self.centerButtonItem
      .setImage(UIImage(named: named),
                for: .normal)
  }
  
  private func didTapCenterButtonItem() {
    self.centerButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        let checkMannerAlerControllr = CheckMannerAlertController()
        checkMannerAlerControllr.modalPresentationStyle = .overFullScreen
        
        self.present(checkMannerAlerControllr,
                     animated: false) {
          
          checkMannerAlerControllr
            .useOkButton().rx.tap
            .asDriver()
            .drive(onNext: { self.dismiss(animated: false) })
            .disposed(by: self.bag)
        }
      }).disposed(by: self.bag)
  }
  
  private func keyboardObserv() {
    self.keyboradObservable =
      Observable
      .from([NotificationCenter
              .default
              .rx
              .notification(UIResponder.keyboardWillShowNotification)
              .map { notification -> CGFloat in
                
                (notification
                  .userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?
                  .cgRectValue
                  .height ?? 0
              },
             NotificationCenter
              .default
              .rx
              .notification(UIResponder.keyboardWillHideNotification)
              .map { _ in CGFloat(0) }]).merge()
  }
  
  private func shiftTextView() {
    self.keyboradObservable?
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { height in
        
        UIView.animate(withDuration: 0.5, animations: {
          
          if height > 0 {
            
            self.messageTextView.transform = .init(translationX: 0, y: -268)
            
          } else {
            
            self.messageTextView.transform = .identity
          }
        })
      }).disposed(by: self.bag)
  }
  
  private func textViewPlaceHolder() {
    let textView = self.messageTextView.useInputTextView(),
        placeHolder = self.messageTextView.usePlaceHolderLabel()
    
    textView
      .rx
      .didChange
      .asDriver()
      .drive(onNext: {
        
        placeHolder.isHidden = textView.hasText
        
      }).disposed(by: self.bag)
    
      textView
      .rx
      .didEndEditing
      .asDriver()
        .drive(onNext: {
          
          placeHolder.isHidden = textView.hasText
          
        }).disposed(by: self.bag)
  }
  
  private func sendMessage() {
    let textView = self.messageTextView.useInputTextView(),
        placeHolder = self.messageTextView.usePlaceHolderLabel(),
        sendButton = self.messageTextView.useSendButton()
    
    sendButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        var dateComponents = DateComponents()
        let calendar = Calendar.current
        let dateformatter = DateFormatter().then {
          $0.dateFormat = "h:mm"
        }

        dateComponents.hour = calendar.component(.hour, from: Date())
        dateComponents.minute = calendar.component(.minute, from: Date())

        let date = calendar.date(from: dateComponents)!,
            time = calendar.amSymbol.appending(" ").appending(dateformatter.string(from: date))
        
        if let text = textView.text {
          
          self.joinChattingModel.messages.append([.my: [time, text]])
          print("save message: \(self.joinChattingModel.messages)")
        }
        
        textView.text.removeAll()
        placeHolder.isHidden = textView.hasText
        textView.snp.remakeConstraints {
          $0.center.equalToSuperview()
          $0.width.equalToSuperview().multipliedBy(0.9)
          $0.height.equalTo(CommonLength.shared.height(28))
        }
        self.messageTextView.snp.remakeConstraints {
          $0.width.centerX.equalToSuperview()
          $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
          $0.height.equalTo(CommonLength.shared.height(58))
        }
        
      }).disposed(by: self.bag)      
  }
  
  private func popViewController() {
    self.leftButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
      
        self.navigationController?
          .popViewController(animated: true)
        
      }).disposed(by: self.bag)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.joinChattingModel.messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let chattingCell = tableView.dequeueReusableCell(withIdentifier: ChattingTableViewCell.ID,
                                                           for: indexPath) as? ChattingTableViewCell else { fatalError("chatting cell error") }
    
    chattingCell.useProfileImageView().isHidden = true
    
    let messageView = chattingCell.useMessageView().then {
      $0.roundCorners(cornerRadius: 10,
                      maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner])
      $0.backgroundColor = UIColor.joinusColor.defaultPhotoGray
    }
    
    messageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(10))
        $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(10))
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(17))
    }
    
    let userNameLabel = messageView.useUserNameLabel(),
        messageLabel = messageView.useMessageLabel(),
        sendTimeLabel = messageView.useSendTimeLabel()
    
    userNameLabel.textColor = .white
    messageLabel.textColor = .white
    
    userNameLabel.text = "테스트 아이디"//self.myInfoModel.myGameID
    sendTimeLabel.text = self.joinChattingModel.messages[indexPath.row][.my]?[0]
    messageLabel.text = self.joinChattingModel.messages[indexPath.row][.my]?[1]
    
    return chattingCell
  }
  
  private func setTapGestureAction() {
    self.tapGesture
      .rx
      .event
      .asDriver()
      .drive(onNext: { _ in
        
        self.messageTextView.useInputTextView().endEditing(true)
        
      }).disposed(by: self.bag)
  }
}
