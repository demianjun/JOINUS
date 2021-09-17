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
  
  private var roomInfo: GetRoomInfo,
              joinJangPk: Int
  
  private let calculateAboutTime = CalculateAboutTime(),
              tier = TierToString(),
              downLoad = DownLoad()
  
  // MARK: Manager
  private let roomUser = RoomUserService.manager
  
  // MARK: Model
  private let joinChattingModel = JoinChattingModel.shared
  
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
  
  init(roomInfo: GetRoomInfo, joinJangPk: Int) {
    self.roomInfo = roomInfo
    self.joinJangPk = joinJangPk
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = #colorLiteral(red: 0.8783445954, green: 0.8784921765, blue: 0.8783251643, alpha: 1)
    self.joinChattingModel.selectedRoomPk = self.roomInfo.roomPk
    self.joinChattingModel.selectedRoomManner = Int(self.roomInfo.roomManner / self.roomInfo.userList.count)
    self.setupView()
    self.aboutCollectionView()
    self.setNavigationBar()
    self.popViewController()
    self.didTapJoinButton()
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
    
    let joinPeople = "\(self.roomInfo.userList.count)/\(self.roomInfo.peopleNumber)",
        tierRange = self.tier.selectTierRange(lowest: self.roomInfo.lowestTier,
                                              highest: self.roomInfo.highestTier)
    
    var range = String()
    if tierRange.count == 2 {
      range = "\(tierRange[0]) > \(tierRange[1])"
    } else {
      range = "\(tierRange[0])"
    }
    
    self.joinGameView.useTitleLabel().text = self.roomInfo.roomName
    self.joinGameView.useJoinPeople().useListContentLabel().text = joinPeople
    self.joinGameView.useStartGameDate().useListContentLabel().text = self.calculateAboutTime.strDateToString(self.roomInfo.startDate)
    self.joinGameView.useTierOfStandard().useListContentLabel().text = range
    self.joinGameView.useVoiceChatCheck().useListContentLabel().text = "\(self.roomInfo.voiceChat)"
  }
  
  private func didTapJoinButton() {
    let joinChattingVC = JoinChattingViewController()
    
    CommonAction.shared.touchActionEffect(self.joinButton) {
//      joinChattingVC.roomInfo = self.roomInfo
      
//      self.navigationController?
//        .pushViewController(joinChattingVC,
//                            animated: true)

      self.roomUser.postRoomUser { res in
        joinChattingVC.roomInfo = self.roomInfo
        if res == 1 {

          self.navigationController?
            .pushViewController(joinChattingVC,
                                animated: true)

        } else {

          let joinusAlertVC = JoinusAlertController(title: .top,
                                                    title: "참여 할 수 없습니다ㅠ",
                                                    explain: "사람이 꽉 찼거나 게임이 시작되었습니다.\n다른 방에 조인해보세요"),
            okButton = JoinusButton(title: "확인",
                                    titleColor: .white,
                                    backGroundColor: UIColor.joinusColor.joinBlue)

          joinusAlertVC.addAction(okButton)

          self.present(joinusAlertVC,
                       animated: false) {
            okButton.rx.tap.asDriver().drive { self.dismiss(animated: false) }.disposed(by: self.bag)
          }
        }
      }
    }
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
  
  func useJoinButton() -> JoinusButton {
    return self.joinButton
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

    let joinJangMarkLabel = UILabel().then {
      $0.text = "조 인 장"
      $0.font = UIFont.joinuns.font(size: 10)
      $0.textColor = UIColor.joinusColor.joinBlue
    }
    joinProfileCell.addSubview(joinJangMarkLabel)
    
    
    joinProfileCell.useProfileImageView().image = self.downLoad.imageURL(image: userInfo.imageAddress)
    joinProfileCell.useUserNameLabel().text = userInfo.nickName
    
    if self.joinJangPk == userInfo.joinUserPk {
      joinJangMarkLabel.snp.makeConstraints {
        $0.bottom.equalTo(joinProfileCell.useUserNameLabel().snp.bottom).offset(2)
        $0.centerX.equalTo(joinProfileCell.useUserNameLabel())
      }
    }
    
    return joinProfileCell
  }
}
