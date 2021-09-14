//
//  GameListViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/07.
//

import UIKit
import RxSwift

class HomeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  private let bag = DisposeBag()
  
  private let calculateAboutTime = CalculateAboutTime()
  
  // MARK: Manager
  private let service = Service.manager
  
  // MARK: ViewModel
  private let homeListViewModel = HomeListViewModel()
  
  // MARK: Model
  private let homeListModel = HomeListModel.shared
  
  // MARK: View
  private let navigationView = CustomNavigationView()
  
  private let customLeftBarButton = CustomLeftBarButton()

  private let customRightBarButton = CustomRightBarButton()

  private let joinusListTableView = UITableView().then {
    $0.backgroundColor = .white
  }
  
  private let creatMatchingRoomButton = UIButton().then {
    $0.setImage(UIImage(named: "group57"),
                for: .normal)
  }
  
  private let tooltipImageView = UIImageView().then {
    $0.image = UIImage(named: "Tooltip")
  }
  
  private let tooltipLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.text = "버튼을 눌러 매칭방을\n만드실 수 있어요."
    $0.textColor = .white
    $0.textAlignment = .center
    $0.font = UIFont.joinuns.font(size: 15)
  }
  
  private let refresh = UIRefreshControl().then {
    $0.tintColor = UIColor.joinusColor.joinBlue
    $0.attributedTitle = NSAttributedString(string: "새로 생성된 방을 불러오고 있습니다.",
                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.joinusColor.joinBlue,
                                                         NSAttributedString.Key.font : UIFont.joinuns.font(size: 13)])
  }
  
  override func loadView() {
    super.loadView()
    self.homeListModel
      .tableView = self.joinusListTableView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.joinusListTableView.refreshControl = self.refresh
    self.service
      .getHomeListInfo() {
        
        self.setupUI()
        self.setNavigationBar()
        self.joinusListTableView.delegate = self
        self.joinusListTableView.dataSource = self
        self.joinusListTableView.register(JoinusCustomCell.self,
                                          forCellReuseIdentifier: JoinusCustomCell.ID)
    }
    
    self.didTapMakeMatchingButton()
    self.refreshTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  private func setupUI() {
    [navigationView, joinusListTableView, creatMatchingRoomButton, tooltipImageView].forEach { self.view.addSubview($0) }
    self.tooltipImageView.addSubview(self.tooltipLabel)
    
    navigationView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(100))
    }
    
    joinusListTableView.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    creatMatchingRoomButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(20))
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-CommonLength.shared.width(20))
      $0.width.height.equalTo(CommonLength.shared.width(60))
    }
    
    tooltipImageView.snp.makeConstraints {
      $0.trailing.equalTo(creatMatchingRoomButton).offset(5)
      $0.bottom.equalTo(creatMatchingRoomButton.snp.top)
      $0.width.equalTo(CommonLength.shared.width(170))
      $0.height.equalTo(CommonLength.shared.height(70))
    }
    
    tooltipLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(CommonLength.shared.height(10))
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      UIView.animate(withDuration: 1.0) {
        self.tooltipImageView.alpha = 0.0
      }
    }
  }
  
  private func setNavigationBar() {
    [customLeftBarButton, customRightBarButton].forEach { self.navigationView.addSubview($0) }
    
    customLeftBarButton.snp.makeConstraints {
      $0.leading.equalTo(CommonLength.shared.width(17))
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.width(20))
    }
    
    customRightBarButton.snp.makeConstraints {
      $0.trailing.equalTo(-CommonLength.shared.width(17))
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.width(20))
    }
    
    self.navigationController?.navigationBar.isHidden = true
  }
  
  private func refreshTableView() {
    self.refresh
      .rx
      .controlEvent(.valueChanged)
      .asDriver()
      .drive(onNext: {
        
        self.service
          .getHomeListInfo() {
            
            self.refresh.endRefreshing()
          }
      }).disposed(by: self.bag)
  }

  private func didTapMakeMatchingButton() {
    self.creatMatchingRoomButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        let makeMatchingVC = MakeMatchingViewController()
        
        self.navigationController?
          .pushViewController(makeMatchingVC, animated: true)
        
      }).disposed(by: self.bag)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("-> count: \(self.homeListModel.gameList.count)")
    return self.homeListModel.gameList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let gameListCell = tableView.dequeueReusableCell(withIdentifier: JoinusCustomCell.ID,
                                                           for: indexPath) as? JoinusCustomCell else { fatalError("custom cell return") }
    
    gameListCell.selectionStyle = .none
    
    let temp = self.homeListModel.gameList[indexPath.row],
        createdAt = temp.createdAt,
        startDate = temp.startDate,
        createdInterval = self.calculateAboutTime.calculateCreatedTime(created: createdAt),
        startInterval = self.calculateAboutTime.calculateStartTime(start: startDate),
        leaderPk = temp.leaderPk,
        peopleCount = temp.nowPeopleCnt,
        peopleNum = temp.peopleNumber
    
    var joinJangID = String()
    
        self.homeListModel.gameList[indexPath.row].userList.forEach {
          
          if leaderPk == $0.pk {
            joinJangID = $0.nickName
          }
        }

    if startInterval.contains("완료") {
      
      gameListCell.useStartLabel().backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
      gameListCell.useStartLabel().textColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
      
    } else {
      
      gameListCell.useStartLabel().backgroundColor = UIColor.joinusColor.defaultPhotoGray
      gameListCell.useStartLabel().textColor = .white
    }
    
    if (createdInterval == "방금 전") ||
       (createdInterval == "1분 전") ||
       (createdInterval == "2분 전") ||
       (createdInterval == "3분 전") ||
       (createdInterval == "4분 전") ||
       (createdInterval == "5분 전") {
        
        gameListCell.useNewLabel().isHidden = false
      
    } else {
      
      gameListCell.useNewLabel().isHidden = true
    }
    
    gameListCell.useJoinJangLabel().text = joinJangID
    gameListCell.useTitleLabel().text = temp.roomName
    gameListCell.usePersonCountLabel().text = "\(peopleCount)/\(peopleNum)"
    gameListCell.useStartLabel().text = startInterval
    gameListCell.useCreatedTimeLabel().text = createdInterval
    
    return gameListCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let roomInfo = self.homeListModel.gameList[indexPath.row],
        joinPeopleNum = roomInfo.userList.count
    
    let selectJoinGameVC = SelectJoinGameViewController(roomInfo: roomInfo)

    let joinGameView = selectJoinGameVC.useJoinGameView(),
        voiceChatCheck = joinGameView.useVoiceChatCheck(),
        joinGameCollectionView = joinGameView.useJoinPeopleProfileCollectionView()
   
    joinGameCollectionView.snp.makeConstraints {
      $0.top.equalTo(voiceChatCheck.snp.bottom).offset(CommonLength.shared.height(22))
      $0.height.equalTo(CommonLength.shared.height(70))
      $0.width.equalTo(CommonLength.shared.width(70) * CGFloat(joinPeopleNum) + 10)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(22))
    }
    
    self.navigationController?.pushViewController(selectJoinGameVC, animated: true)
//    let naviVC = self.tabBarController?.customizableViewControllers?[0] as? UINavigationController
//    naviVC?.pushViewController(selectJoinGameVC, animated: true)
  }
}
