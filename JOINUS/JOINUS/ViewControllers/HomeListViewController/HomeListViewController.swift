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
  
  private let creatMatchingRoomButton = UIButton()
  
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
        self.joinusListTableView
          .register(JoinusCustomCell.self,
                    forCellReuseIdentifier: JoinusCustomCell.ID)
        self.joinusListTableView.reloadData()
      }
  }
  
  private func setupUI() {
    [joinusListTableView].forEach { self.view.addSubview($0) }
    
    joinusListTableView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
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
    
    let temp = self.homeListModel.gameList[indexPath.row],
        createdAt = self.homeListModel.gameList[indexPath.row].createdAt,
        timeInterval = self.calculateCreatedTime(created: createdAt)
    
    gameListCell.useJoinJangLabel().text = "aaaa \(indexPath.row + 1)"
    gameListCell.useTitleLabel().text = temp.roomName
    gameListCell.usePersonCountLabel().text = "\(indexPath.row + 1)/5"
    gameListCell.useStartLabel().text = "cccc \(indexPath.row + 1)"
    gameListCell.useNewLabel().isHidden = false
    gameListCell.useCreatedTimeLabel().text = timeInterval
    
    return gameListCell
  }
  
  
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    <#code#>
//  }
  
  // MARK: Methods
  private func calculateCreatedTime(created time: String) -> String {
    
    let dateFormat = DateFormatter().then {
      $0.locale = Locale(identifier: "Ko_kr")
      $0.dateFormat = "yyyy-MM-dd HH-mm-ss"
    },
    currentDate = Date(),
    createdDate = dateFormat.date(from: time) ?? Date()
        
    let temp = currentDate - createdDate
    
    return self.calculateTimeInterval(second: Int(temp))
  }
  
 
  private func calculateTimeInterval(second: Int) -> String {
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
