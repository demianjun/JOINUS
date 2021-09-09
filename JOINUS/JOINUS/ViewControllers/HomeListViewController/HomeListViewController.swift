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
  
  // MARK: Manager
  private let service = Service.manager
  
  // MARK: ViewModel
  private let homeListViewModel = HomeListViewModel()
  
  // MARK: Model
  private let homeListModel = HomeListModel.shared
  
  // MARK: View
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
  
  override func loadView() {
    super.loadView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    self.service
      .getHomeListInfo() {
        
        self.setupUI()
        self.setNavigationBar()
        self.joinusListTableView.delegate = self
        self.joinusListTableView.dataSource = self
        self.joinusListTableView.register(JoinusCustomCell.self,
                                          forCellReuseIdentifier: JoinusCustomCell.ID)
        
        self.joinusListTableView.reloadData()
      }
  }
  
  private func setupUI() {
    [joinusListTableView, creatMatchingRoomButton, tooltipImageView].forEach { self.view.addSubview($0) }
    self.tooltipImageView.addSubview(self.tooltipLabel)
    
    joinusListTableView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
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
    let customLeftBarButton = UIBarButtonItem(customView: self.customLeftBarButton),
        customRightBarButton = UIBarButtonItem(customView: self.customRightBarButton)
    
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
    self.navigationController?.navigationBar.layer.shadowColor = #colorLiteral(red: 0.4509803922, green: 0.4509803922, blue: 0.4509803922, alpha: 1)
    self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
    self.navigationController?.navigationBar.topItem?.title = ""
    self.navigationItem.leftBarButtonItem = customLeftBarButton
    self.navigationItem.rightBarButtonItem = customRightBarButton
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
        createdInterval = self.calculateCreatedTime(created: createdAt),
        startInterval = self.calculateStartTime(start: startDate),
        leaderPk = temp.leaderPk,
        peopleCount = temp.nowPeopleCnt,
        peopleNum = temp.peopleNumber
    
    var joinJangID = String()
    
        self.homeListModel.gameList[indexPath.row].userList.forEach {
          
          if leaderPk == $0.pk {
            joinJangID = $0.nickName
          }
        }
    
    if startInterval == "매칭 완료" {
      gameListCell.useStartLabel().backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
      gameListCell.useStartLabel().textColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
    }
    
    if (createdInterval == "1분 전") ||
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
    print("tap tap tap tap")
    let joinGameVC = JoinGameViewController(roomInfo: self.homeListModel.gameList[indexPath.row]),
//        joinGameViewModel = joinGameVC.joinGameViewModel,
        joinGameNaviVC = UINavigationController(rootViewController: joinGameVC)

    joinGameNaviVC.modalPresentationStyle = .fullScreen
    
    self.present(joinGameNaviVC,
                 animated: true)
  }
  
  // MARK: Methods
  private func calculateStartTime(start time: String) -> String {
    let dateFormat = DateFormatter()
    dateFormat.locale = Locale(identifier: "Ko_kr")
    dateFormat.dateFormat = "yyyy-MM-dd"// HH-mm-ss"
    
    let dateFormat1 = DateFormatter()
    dateFormat1.locale = Locale(identifier: "Ko_kr")
    dateFormat1.dateFormat = "yyyy-MM-dd HH-mm-ss"
    
    var second = Int()
    
    let currentDate = Date(),
        currentDayString = dateFormat.string(from: currentDate).components(separatedBy: " ")[0],
        currentDay = dateFormat.date(from: currentDayString)!
    
    let startDate = dateFormat1.date(from: time)!,
        startDayString = time.components(separatedBy: " ")[0],
        startDay = dateFormat.date(from: startDayString)!
    
    let dateInterval = startDate - currentDate,//currentDate.distance(to: dateFormat1.date(from: time)!),
        dayInterval = startDay - currentDay//currentDay1.distance(to: startDay1)
    
    if dayInterval == 0 {
      
      second = Int(dateInterval)
     
    } else if (60 <= dayInterval), (dayInterval <= (60 * 60 * 24)) {
      
      second = Int(dayInterval)
      
    } else if (60 * 60 * 24) < dayInterval {
      
      second = Int(dayInterval)
      
    }
    
    return self.calculateStartTimeInterval(second: second)
  }
  
  private func calculateStartTimeInterval(second: Int) -> String {
    var day = String()
    
    if (60 <= second), (second < (60 * 60 * 24)) {
      
      day = "오늘 시작"
      
    } else if ((60 * 60 * 24) <= second), (second < (60 * 60 * 24 * 2)) {
      
      day = "내일 시작"
      
    } else if (60 * 60 * 24 * 2) <= second {
      
      day = "\(Int(second / (60 * 60 * 24)))일 뒤"
      
    } else if second <= 0 {
      
      day = "매칭 완료"
      
    }
    
    return day
  }
  
  private func calculateCreatedTime(created time: String) -> String {
    
    let dateFormat = DateFormatter().then {
      $0.locale = Locale(identifier: "Ko_kr")
      $0.dateFormat = "yyyy-MM-dd HH-mm-ss"
    },
    currentDate = Date(),
    createdDate = dateFormat.date(from: time) ?? Date()
        
    let temp = currentDate - createdDate
    
    return self.calculateCreatedTimeInterval(second: Int(temp))
  }
  
  private func calculateCreatedTimeInterval(second: Int) -> String {
    var day = String()
    
    if (60 <= second), (second < 3600) {
      
      day = "\(Int(second / 60))분 전"
      
    } else if (360 <= second), (second < (60 * 60 * 24)) {
      
      day = "\(Int(second / 3600))시간 전"
      
    } else if ((60 * 60 * 24) <= second), (second < (60 * 60 * 24 * 2)) {
      
      day = "어제"
      
    } else if (60 * 60 * 24 * 2) <= second {
      
      day = "\(Int(second / (60 * 60 * 24)))일 전"
    }
    
    return day
  }
}
