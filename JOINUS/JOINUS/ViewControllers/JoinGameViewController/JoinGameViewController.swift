//
//  JoinGameViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/10.
//


import UIKit
import RxSwift

class JoinGameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  private let bag = DisposeBag()
  
  private var roomInfo: RoomInfo
  
  // MARK: ViewModel
  public let joinGameViewModel = JoinGameViewModel()
  
  // MARK: View
  private let backGroundView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
  }
  
  private let joinGameView = JoinGameView().then {
    $0.layer.cornerRadius = 2
  }
  
  private let joinButton = JoinusButton(title: "참가하기",
                                        titleColor: .white,
                                        backGroundColor: UIColor.joinusColor.joinBlue)

  private let leftButtonItem = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"),
                for: .normal)
    $0.transform = .init(scaleX: 5.0, y: 2.0)
  }
  
  private let naviBarTitleLabel = UILabel().then {
    $0.text = "매칭 참가"
    $0.font = UIFont.joinuns.font(size: 19)
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  init(roomInfo: RoomInfo) {
    self.roomInfo = roomInfo
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .clear
    self.setupView()
    self.setNavigationBar()
    self.aboutCollectionView()
    self.popViewController()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func inputRoomInfo(roomInfo: RoomInfo) {
    self.roomInfo = roomInfo
  }
  
  private func setupView() {
    [backGroundView, joinGameView, joinButton].forEach { self.view.addSubview($0) }
    
    backGroundView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    joinGameView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(CommonLength.shared.height(17))
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.centerX.equalToSuperview()
    }
    
    joinButton.snp.makeConstraints {
      $0.top.equalTo(joinGameView.snp.bottom).offset(CommonLength.shared.height(17))
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.height.equalTo(CommonLength.shared.height(50))
      $0.centerX.equalToSuperview()
    }
    
    let joinPeople = "\(self.roomInfo.userList.count)/\(self.roomInfo.peopleNumber)"
    
    self.joinGameView.useTitleLabel().text = self.roomInfo.roomName
    self.joinGameView.useJoinPeople().useListContentLabel().text = joinPeople
    self.joinGameView.useStartGameDate().useListContentLabel().text = self.roomInfo.startDate
    self.joinGameView.useTierOfStandard().useListContentLabel().text = "\(self.roomInfo.lowestTier)"
    self.joinGameView.useVoiceChatCheck().useListContentLabel().text = "\(self.roomInfo.voiceChat)"
  }
  
  private func setNavigationBar() {
    self.leftButtonItem.bounds = self.leftButtonItem.bounds.offsetBy(dx: 0, dy: 100)
    self.naviBarTitleLabel.bounds = self.naviBarTitleLabel.bounds.offsetBy(dx: 0, dy: 100)
    let customLeftBarButton = UIBarButtonItem(customView: self.leftButtonItem)
        
    self.navigationController?.additionalSafeAreaInsets.top = 50
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
    self.navigationController?.navigationBar.layer.shadowColor = #colorLiteral(red: 0.4509803922, green: 0.4509803922, blue: 0.4509803922, alpha: 1)
    self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
    self.navigationController?.navigationBar.topItem?.titleView = self.naviBarTitleLabel
    self.navigationController?.navigationBar.topItem?.title = ""
    self.navigationItem.leftBarButtonItem = customLeftBarButton
  }
  
  private func popViewController() {
    self.leftButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.dismiss(animated: true)
//        self.navigationController?
//          .popViewController(animated: true)
        
      }).disposed(by: self.bag)
  }
  
  func aboutCollectionView() {
    let collectionView = self.joinGameView.useJoinPeopleProfileCollectionView().useSelectedCollectionView()
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  func useJoinGameView() -> JoinGameView {
    return self.joinGameView
  }
  
  // MARK: Delegate
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.roomInfo.userList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let joinProfileCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: JoinProfileCell.ID,
                                 for: indexPath) as? JoinProfileCell else { fatalError("join profile cell return") }
    
    let userInfo = self.roomInfo.userList[indexPath.row]
    
//    joinProfileCell.useProfileImageView().image = UIImage(named: userInfo.imageAddress ?? "defaultProfile_60x60")
    joinProfileCell.useProfileImageView().image = UIImage(named: "defaultProfile_60x60")
    joinProfileCell.useUserNameLabel().text = userInfo.nickName
      
    return joinProfileCell
  }
}
