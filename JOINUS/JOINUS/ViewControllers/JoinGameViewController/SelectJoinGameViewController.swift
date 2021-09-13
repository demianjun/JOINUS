//
//  SelectJoinGameViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/10.
//


import UIKit
import RxSwift

class SelectJoinGameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  private let bag = DisposeBag()
  
  private var roomInfo: GetRoomInfo
  
  // MARK: ViewModel
  public let joinGameViewModel = JoinGameViewModel()
  
  // MARK: View
  private let navigationView = CustomNavigationView()
  
  private let joinGameView = JoinGameView().then {
    $0.layer.cornerRadius = 2
  }
  
  private let joinButton = JoinusButton(title: "참가하기",
                                        titleColor: .white,
                                        backGroundColor: UIColor.joinusColor.joinBlue)
  
  private let leftButtonItem = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"),
                for: .normal)
    $0.tintColor = .black
    $0.transform = .init(scaleX: 1.5, y: 1.5)
  }
  
  private let naviBarTitleLabel = UILabel().then {
    $0.text = "매칭 참가"
    $0.font = UIFont.joinuns.font(size: 19)
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  init(roomInfo: GetRoomInfo) {
    self.roomInfo = roomInfo
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = #colorLiteral(red: 0.8783445954, green: 0.8784921765, blue: 0.8783251643, alpha: 1)
    self.setupView()
    self.setNavigationBar()
    self.aboutCollectionView()
    self.popViewController()
  }
  
  func inputRoomInfo(roomInfo: GetRoomInfo) {
    self.roomInfo = roomInfo
  }
  
  private func setupView() {
    [navigationView, joinGameView, joinButton].forEach { self.view.addSubview($0) }
    
    navigationView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(100))
    }
        
    joinGameView.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom).offset(CommonLength.shared.height(17))
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
    [leftButtonItem, naviBarTitleLabel].forEach { self.navigationView.addSubview($0) }
    
    naviBarTitleLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(20))
      $0.centerX.equalToSuperview()
    }
    
    leftButtonItem.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
      $0.centerY.equalTo(naviBarTitleLabel)
      $0.width.height.equalTo(CommonLength.shared.width(15))
    }
    
    self.tabBarController?.tabBar.isHidden = true
    self.navigationController?.navigationBar.isHidden = true
  }
  
  private func popViewController() {
    self.leftButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.navigationController?
          .popViewController(animated: true)
        
        self.tabBarController?.tabBar.isHidden = false
        
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
