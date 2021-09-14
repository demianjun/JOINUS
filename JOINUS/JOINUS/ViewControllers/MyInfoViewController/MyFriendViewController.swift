//
//  MyFriendViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit
import RxSwift

class MyFriendViewContrller: UIViewController, UITableViewDelegate, UITableViewDataSource {
  private let bag = DisposeBag()
  
  private let downLoad = DownLoad()
  
  // MARK: Manager
  private let connection = ConnectionService.manager
  
  // MARK: Model
  private let myInfoModel = MyInfoModel.shared
  
  // MARK: View
  private let navigationView = CustomNavigationView()
  
  private let friendTableView = UITableView().then {
    $0.backgroundColor = .white
  }
  
  private let noCountFriendImageView = NoCountImageView(type: .friend).then {
    $0.isHidden = true
  }
  
  private let leftButtonItem = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"),
                for: .normal)
    $0.tintColor = .black
    $0.transform = .init(scaleX: 1.5, y: 1.5)
  }
  
  private let naviBarTitleLabel = UILabel().then {
    $0.text = "친구목록"
    $0.font = UIFont.joinuns.font(size: 19)
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  // MARK: Life Cycle
  override func loadView() {
    super.loadView()
    self.myInfoModel.friendTableView = self.friendTableView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.friendTableView.dataSource = self
    self.friendTableView.delegate = self
    self.friendTableView.register(FriendTableViewCell.self,
                                  forCellReuseIdentifier: FriendTableViewCell.ID)
    
    self.setupView()
    self.setNavigationBar()
    self.popViewController()
    
    self.connection.getConnection(isFriend: true) {
      
      if self.myInfoModel.getFriend.isEmpty {
        
        self.friendTableView.isHidden = true
        self.noCountFriendImageView.isHidden = false
        
      }
    }
  }
  
  private func setupView() {
    [navigationView, friendTableView, noCountFriendImageView].forEach { self.view.addSubview($0) }
    
    navigationView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(100))
    }
    
    friendTableView.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom)
      $0.width.centerX.bottom.equalToSuperview()
    }
    
    noCountFriendImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
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
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.myInfoModel.getFriend.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let friendCell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.ID,
                                                         for: indexPath) as? FriendTableViewCell else { fatalError("friend tableView cell err") }
    
    let getConnection = self.myInfoModel.getFriend[indexPath.row]
    
    friendCell.useNickNameLabel().text = getConnection.nickName
    friendCell.useProfileImageView().image = self.downLoad.imageURL(image: getConnection.imageAddress)
    
    return friendCell
  }
}
