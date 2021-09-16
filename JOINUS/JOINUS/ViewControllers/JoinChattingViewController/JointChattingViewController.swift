//
//  JointChattingViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit
import RxSwift
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class JoinChattingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {//WebSocketDelegate {
  
  private let bag = DisposeBag()
  
  public var roomInfo: GetRoomInfo?
  
  private var keyboradObservable: Observable<CGFloat>?
  
  private let tapGesture = UITapGestureRecognizer()
  
  private var joinusDB: Firestore?,
              joinusChat: CollectionReference?
  
  // MARK: Manager

  
  // MARK: Model
  private let joinChattingModel = JoinChattingModel.shared,
              myInfoModel = MyInfoModel.shared
  
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
  
  private var listener: ListenerRegistration?
  
  // MARK: LifeCycle
  deinit {
    print("deinit")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.messageTextView.useInputTextView().delegate = self
    self.chattingTableView.delegate = self
    self.chattingTableView.dataSource = self
    self.joinChattingModel.chattingTableView = self.chattingTableView
    self.chattingTableView.register(ChattingTableViewCell.self,
                                    forCellReuseIdentifier: ChattingTableViewCell.ID)
    
    let settings = FirestoreSettings()
    
    Firestore.firestore().settings = settings
    
    self.joinusDB = Firestore.firestore()
    self.joinusChat = self.joinusDB?.collection("JoinusChatting")
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

    self.addDocumentFromChattingRoom() {
    
    self.getMessage()
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    print("dddd")
    self.listener?.remove()
    self.joinChattingModel.messages.removeAll()
  }
  
  private func setupView() {
    [navigationView, chattingTableView, messageTextView].forEach { self.view.addSubview($0) }
    
    navigationView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(100))
    }
    
    chattingTableView.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom)
      $0.bottom.greaterThanOrEqualTo(messageTextView.snp.top)
      $0.width.centerX.equalToSuperview()
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
        
        if height > 0 {
          
          self.messageTextView.snp.updateConstraints {
            $0.width.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-265)
            $0.height.equalTo(CommonLength.shared.height(58))
          }
          
        } else {
          
          self.messageTextView.snp.updateConstraints {
            $0.width.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(CommonLength.shared.height(58))
          }
        }
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear, animations: {
          self.view.layoutIfNeeded()
        }, completion: nil)
  
        self.chattingScroll()
        
      }).disposed(by: self.bag)
  }
  
  private func chattingScroll() {
    if self.joinChattingModel.messages.count > 3 {

      self.chattingTableView
        .scrollToRow(at: [0, self.joinChattingModel.messages.count - 1],
                     at: .bottom,
                     animated: true)
    }
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
            sendTime = calendar.amSymbol.appending(" ").appending(dateformatter.string(from: date))
        
        if !textView.text.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
          
          if let message = textView.text,
             message.count != 0 {
            
            self.setDBdata(userPk: 2,
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
  
  private func addDocumentFromChattingRoom(com: (()->())? = nil) {
    self.joinusChat?
      .document("\(self.roomInfo!.roomPk)")
      .setData(["join": "채팅방에 참가 하였습니다."])
      com?()
  }
  
  let testLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 18)
    $0.textColor = .black
  }
  
  private func getMessage() {
    var type: JoinChattingModel.chat?
    
    self.listener =
      self.joinusChat?
      .document("\(self.roomInfo!.roomPk)")
      .addSnapshotListener { docuSnapShot, err in
        
        if let err = err {
          
          print("Error fetching document: \(err)")
          return
          
        } else {
          
          guard let snapShot = docuSnapShot else { return print("snapshot return.") }
          guard let data = snapShot.data() else { return print("Document data was empty.") }
          
          data.keys.forEach {
            
            guard var sendTime = data["sendTime"] as? String else { return }
            guard var message = data["message"] as? String else { return }
            
            if ($0 != "sendTime"),
               ($0 != "message") {
              
              if $0 == "join" {
                type = .join
                
                message = ""
                sendTime = ""
                
              } else if $0 == "\(self.myInfoModel.myPk)" {
                type = .my
                
              } else {
                type = .other
                
              }
              
              guard let userPk = data[$0] as? String else { return }
              self.joinChattingModel.messages.append([type!: ["\(userPk)", sendTime, message]])
            }
          }
          
          self.chattingScroll()
          
          print("-> saved message: \(self.joinChattingModel.messages)")
        }
      }
  }
  
  private func setDBdata(userPk: Int, sendTime: String, message: String) {
    
    self.joinusChat?
      .document("\(self.roomInfo!.roomPk)")
      .setData(["\(userPk)": "\(userPk)",
                "sendTime": sendTime,
                "message": message])
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
  
  private func setTapGestureAction() {
    self.tapGesture
      .rx
      .event
      .asDriver()
      .drive(onNext: { _ in
        
        self.messageTextView.useInputTextView().endEditing(true)
        
      }).disposed(by: self.bag)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.joinChattingModel.messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let chattingCell = tableView.dequeueReusableCell(withIdentifier: ChattingTableViewCell.ID,
                                                           for: indexPath) as? ChattingTableViewCell else { fatalError("chatting cell error") }
    
    chattingCell.selectionStyle = .none
    
    let down = DownLoad()
    
    let messageView = chattingCell.useMessageView(),
        useProfile = chattingCell.useProfileImageView(),
        userNameLabel = messageView.useUserNameLabel(),
        messageLabel = messageView.useMessageLabel(),
        sendTimeLabel = messageView.useSendTimeLabel(),
        messageData = self.joinChattingModel.messages[indexPath.row]
    
    var nameAndMessageColor = UIColor(),
        timeColor = UIColor(),
        profileImage: UIImage?,
        name = String(),
        sendTime = String(),
        message = String(),
        otherUser = String(),
        imageAdd = String()
    
    messageData.keys.forEach { key in

      switch key {
        
        case .join:
          
          chattingCell.addSubview(self.testLabel)
          
          self.testLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
          }
          
          self.testLabel.text = messageData[.join]?[2]
          
        case .my:
          
          useProfile.isHidden = true
          
          messageView.roundCorners(cornerRadius: 10,
                                   maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner])
          messageView.backgroundColor = UIColor.joinusColor.defaultPhotoGray
          
          messageView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(CommonLength.shared.height(10))
            $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(10))
            $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(17))
          }
          
          nameAndMessageColor = .white
          timeColor = .black.withAlphaComponent(0.6)
          profileImage = UIImage()
          name = "MyNickName"//self.myInfoModel.myGameID
          sendTime = messageData[.my]?[1] ?? ""
          message = messageData[.my]?[2] ?? ""
          
        case .other:
          
          useProfile.isHidden = false
          
          messageView.roundCorners(cornerRadius: 10,
                                   maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner])
          messageView.backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
          
          useProfile.snp.makeConstraints {
            $0.width.height.equalTo(CommonLength.shared.width(60))
            $0.top.equalToSuperview().offset(CommonLength.shared.height(10))
            $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
          }
          
          messageView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(CommonLength.shared.height(10))
            $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(10))
            $0.leading.equalTo(useProfile.snp.trailing).offset(CommonLength.shared.width(10))
          }
          
          self.roomInfo?.userList.forEach { info in
            
            if info.joinUserPk == Int(messageData[.other]?[0] ?? "0") {
              otherUser = info.nickName
              imageAdd = info.imageAddress
            }
          }
          
          nameAndMessageColor = .black
          timeColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
          profileImage = down.imageURL(image: imageAdd)//UIImage(named: "defaultProfile_60x60")
          name = otherUser
          sendTime = messageData[.other]?[1] ?? ""
          message = messageData[.other]?[2] ?? ""
          
      }
    }
    userNameLabel.textColor = nameAndMessageColor
    messageLabel.textColor = nameAndMessageColor
    sendTimeLabel.textColor = timeColor
    useProfile.image = profileImage
//    useProfile.image = UIImage(named: "defaultProfile_60x60")
    
    userNameLabel.text = name
    sendTimeLabel.text = sendTime
    messageLabel.text = message
    
    return chattingCell
  }
}
