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
  
  let bag = DisposeBag()
  
  public var roomInfo: GetRoomInfo?
  
  private var keyboradObservable: Observable<CGFloat>?
  
  private let tapGesture = UITapGestureRecognizer()
  
  var joinusDB: Firestore?,
      joinusChat: CollectionReference?
  
  var snapShots = [QueryDocumentSnapshot]() {
    didSet {
      self.chattingTableView.reloadData()
    }
  }
  
  var isJoinjang = Bool()
  
  // MARK: Manager
  
  
  // MARK: Model
  let joinChattingModel = JoinChattingModel.shared,
      myInfoModel = MyInfoModel.shared
  
  // MARK: View
  let navigationView = CustomNavigationView()
  
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
  
  private let topToolTipImageView = UIImageView().then {
    $0.image = UIImage(named: "top_tootip")
  }
  
  private let topToolTipLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.text = "이모티콘을 눌러서\n매너도를 확인해보세요."
    $0.textColor = .white
    $0.textAlignment = .center
    $0.font = UIFont.joinuns.font(size: 15)
  }
  
  let gameStartView = StartGameButtonView().then {
    $0.backgroundColor = .white
  }
  
  let chattingTableView = UITableView().then {
    $0.backgroundColor = .white
    $0.separatorStyle = .none
  }
  
  let messageTextView = MessageTextView()
  
  var listener: ListenerRegistration?
  
  // MARK: LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    self.messageTextView.useInputTextView().delegate = self
    self.chattingTableView.delegate = self
    self.chattingTableView.dataSource = self
    //    self.joinChattingModel.chattingTableView = self.chattingTableView
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
    self.didTapPeopleRightButton()
    self.didTapGameStartButton()
    self.didTapGameEndButton()
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
    
    self.listener?.remove()
  }
  
  private func setupView() {
    [navigationView, gameStartView, chattingTableView, messageTextView, topToolTipImageView].forEach { self.view.addSubview($0) }
    
    self.topToolTipImageView.addSubview(topToolTipLabel)
    
    navigationView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(100))
    }
    
    if self.isJoinjang {
      
      gameStartView.snp.makeConstraints {
        $0.top.equalTo(navigationView.snp.bottom)
        $0.width.centerX.equalToSuperview()
      }
      
      chattingTableView.snp.makeConstraints {
        $0.top.equalTo(gameStartView.snp.bottom)
        $0.bottom.greaterThanOrEqualTo(messageTextView.snp.top)
        $0.width.centerX.equalToSuperview()
      }
      
    } else {
      
      chattingTableView.snp.makeConstraints {
        $0.top.equalTo(navigationView.snp.bottom)
        $0.bottom.greaterThanOrEqualTo(messageTextView.snp.top)
        $0.width.centerX.equalToSuperview()
      }
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
    
    topToolTipImageView.snp.makeConstraints {
      $0.top.equalTo(centerButtonItem.snp.bottom)
      $0.leading.equalTo(centerButtonItem).offset(-CommonLength.shared.width(22))
      $0.width.equalTo(CommonLength.shared.width(180))
      $0.height.equalTo(CommonLength.shared.height(70))
    }
    
    topToolTipLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(10))
      $0.centerX.equalToSuperview()
    }
    
    self.naviBarTitleLabel.text = self.roomInfo?.roomName
    
    self.navigationController?.navigationBar.isHidden = true
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      UIView.animate(withDuration: 1.0) {
        self.topToolTipImageView.alpha = 0.0
      }
    }
  }
  
  func didTapPeopleRightButton() {
    let showMatchingJoinerVC = ShowMatchingJoinerViewController()
    showMatchingJoinerVC.joinUsersInfo = self.roomInfo!.userList
    showMatchingJoinerVC.modalPresentationStyle = .overFullScreen
    
    self.peopleRightButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.present(showMatchingJoinerVC,
                     animated: false)
        
      }).disposed(by: self.bag)
  }
  
  let endGameView = EndGameButtonView()
  
  func didTapGameStartButton() {
    self.gameStartView
      .useStartButton()
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.gameStartView.isHidden = true
        self.messageTextView.isHidden = true
          
        self.chattingTableView.snp.remakeConstraints {
          $0.top.equalTo(self.navigationView.snp.bottom)
          $0.bottom.greaterThanOrEqualTo(self.messageTextView.snp.top)
          $0.width.centerX.equalToSuperview()
        }
        
        
        self.view.addSubview(self.endGameView)
        
        self.endGameView.snp.makeConstraints {
          $0.width.bottom.centerX.equalToSuperview()
        }
        
      }).disposed(by: self.bag)
  }
  
  func didTapGameEndButton() {
    self.endGameView.useEndButton()
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        
        
      }).disposed(by: self.bag)
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
  
  func chattingScroll() {
    //    if self.joinChattingModel.messages.count > 3 {
    //
    //      self.chattingTableView
    //        .scrollToRow(at: [0, self.joinChattingModel.messages.count - 1],
    //                     at: .bottom,
    //                     animated: true)
    //    }
    
    if self.snapShots.count > 3 {
      
      self.chattingTableView
        .scrollToRow(at: [0, self.snapShots.count - 1],
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
    //    return self.joinChattingModel.messages.count
    return self.snapShots.count
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
        sendTimeLabel = messageView.useSendTimeLabel()
    
    var nameAndMessageColor = UIColor(),
        timeColor = UIColor(),
        profileImage: UIImage?,
        name = String(),
        sendTime = String(),
        message = String(),
        imageAddress = String()
    
    let dbData = self.snapShots[indexPath.row]
    
    if dbData.data().keys.contains("\(self.myInfoModel.myPk)") {
      
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
      name = dbData.data()["\(self.myInfoModel.myPk)"] as? String ?? "noname"//self.myInfoModel.myGameID
      sendTime = dbData.data()["time"] as? String ?? "notime"
      message = dbData.data()["message"] as? String ?? "nomessage"
      
    } else {
      
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
        if dbData.data()["\(info.joinUserPk)"] != nil {
          
          imageAddress = info.imageAddress
          name = dbData.data()["\(info.joinUserPk)"] as? String ?? "noname"//info.nickName
          sendTime = dbData.data()["time"] as? String ?? "notime"
          message = dbData.data()["message"] as? String ?? "nomessage"
        }
      }
      
      nameAndMessageColor = .black
      timeColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
      profileImage = down.imageURL(image: imageAddress)//UIImage(named: "defaultProfile_60x60")
      
    }
    
    userNameLabel.textColor = nameAndMessageColor
    messageLabel.textColor = nameAndMessageColor
    sendTimeLabel.textColor = timeColor
    useProfile.image = profileImage
    
    userNameLabel.text = name
    sendTimeLabel.text = sendTime
    messageLabel.text = message
    
    return chattingCell
  }
}

//    guard let chattingCell = tableView.dequeueReusableCell(withIdentifier: ChattingTableViewCell.ID,
//                                                           for: indexPath) as? ChattingTableViewCell else { fatalError("chatting cell error") }
//
//    chattingCell.selectionStyle = .none
//
//    let down = DownLoad()
//
//    let messageView = chattingCell.useMessageView(),
//        useProfile = chattingCell.useProfileImageView(),
//        userNameLabel = messageView.useUserNameLabel(),
//        messageLabel = messageView.useMessageLabel(),
//        sendTimeLabel = messageView.useSendTimeLabel(),
//        messageData = self.joinChattingModel.messages[indexPath.row]
//
//    var nameAndMessageColor = UIColor(),
//        timeColor = UIColor(),
//        profileImage: UIImage?,
//        name = String(),
//        sendTime = String(),
//        message = String(),
//        otherUser = String(),
//        imageAdd = String()
//
//    messageData.keys.forEach { key in
//
//      switch key {
//
//        case .join:
//
//          chattingCell.addSubview(self.testLabel)
//
//          self.testLabel.snp.makeConstraints {
//            $0.center.equalToSuperview()
//          }
//
//          self.testLabel.text = messageData[.join]?[2]
//
//        case .my:
//
//          useProfile.isHidden = true
//
//          messageView.roundCorners(cornerRadius: 10,
//                                   maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner])
//          messageView.backgroundColor = UIColor.joinusColor.defaultPhotoGray
//
//          messageView.snp.remakeConstraints {
//            $0.top.equalToSuperview().offset(CommonLength.shared.height(10))
//            $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(10))
//            $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(17))
//          }
//
//          nameAndMessageColor = .white
//          timeColor = .black.withAlphaComponent(0.6)
//          profileImage = UIImage()
//          name = "MyNickName"//self.myInfoModel.myGameID
//          sendTime = messageData[.my]?[1] ?? ""
//          message = messageData[.my]?[2] ?? ""
//
//        case .other:
//
//          useProfile.isHidden = false
//
//          messageView.roundCorners(cornerRadius: 10,
//                                   maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner])
//          messageView.backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
//
//          useProfile.snp.makeConstraints {
//            $0.width.height.equalTo(CommonLength.shared.width(60))
//            $0.top.equalToSuperview().offset(CommonLength.shared.height(10))
//            $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
//          }
//
//          messageView.snp.remakeConstraints {
//            $0.top.equalToSuperview().offset(CommonLength.shared.height(10))
//            $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(10))
//            $0.leading.equalTo(useProfile.snp.trailing).offset(CommonLength.shared.width(10))
//          }
//
//          self.roomInfo?.userList.forEach { info in
//
//            if info.joinUserPk == Int(messageData[.other]?[0] ?? "0") {
//              otherUser = info.nickName
//              imageAdd = info.imageAddress
//            }
//          }
//
//          nameAndMessageColor = .black
//          timeColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
//          profileImage = down.imageURL(image: imageAdd)//UIImage(named: "defaultProfile_60x60")
//          name = otherUser
//          sendTime = messageData[.other]?[1] ?? ""
//          message = messageData[.other]?[2] ?? ""
//
//      }
//    }
//    userNameLabel.textColor = nameAndMessageColor
//    messageLabel.textColor = nameAndMessageColor
//    sendTimeLabel.textColor = timeColor
//    useProfile.image = profileImage
// //    useProfile.image = UIImage(named: "defaultProfile_60x60")
//
//    userNameLabel.text = name
//    sendTimeLabel.text = sendTime
//    messageLabel.text = message
//
//    return chattingCell
//  }
//}
