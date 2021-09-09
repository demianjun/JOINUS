//
//  JoinGameViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/09.
//

import UIKit
import RxSwift

class JoinGameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  private let bag = DisposeBag()
  
  private var roomInfo: RoomInfo
  
  // MARK: ViewModel
  public let joinGameViewModel = JoinGameViewModel()
  
  // MARK: View
  private let joinGameView = JoinGameView().then {
    $0.layer.cornerRadius = 2
  }
  
  private let joinButton = JoinusButton(title: "참가하기",
                                        titleColor: .white,
                                        backGroundColor: UIColor.joinusColor.joinBlue)

  private let leftButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                               style: .plain,
                                               target: nil,
                                               action: nil)
  
  init(roomInfo: RoomInfo) {
    self.roomInfo = roomInfo
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
    self.aboutCollectionView()
    self.setNavigationBar()
    self.setupView()
    self.popViewController()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.loadViewIfNeeded()
  }
  
  private func setupView() {
    [joinGameView, joinButton].forEach { self.view.addSubview($0) }
    
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
    let titleLabel = UILabel().then {
      $0.text = "매칭 참가"
      $0.font = UIFont.joinuns.font(size: 19)
      $0.textColor = .black
      $0.textAlignment = .center
    }
    self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0,
                                                            width: CommonLength.shared.width(375),
                                                            height: CommonLength.shared.height(100))
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationController?.navigationBar.topItem?.titleView = titleLabel
    self.navigationItem.leftBarButtonItem = self.leftButtonItem
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
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.roomInfo.userList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let joinProfileCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: JoinProfileCell.ID,
                                 for: indexPath) as? JoinProfileCell else { fatalError("join profile cell return") }
    
    self.joinGameView
      .useJoinPeopleProfileCollectionView()
      .frame
      .size
      .width = CommonLength.shared.width(70) * CGFloat(self.roomInfo.userList.count)
    
    let userInfo = self.roomInfo.userList[indexPath.row]
    print("useinfo: \(userInfo)")
//    joinProfileCell.useProfileImageView().image = UIImage(named: userInfo.imageAddress ?? "defaultProfile_60x60")
    joinProfileCell.useProfileImageView().image = UIImage(named: "defaultProfile_60x60")
    joinProfileCell.useUserNameLabel().text = userInfo.nickName
      
    return joinProfileCell
  }
}
