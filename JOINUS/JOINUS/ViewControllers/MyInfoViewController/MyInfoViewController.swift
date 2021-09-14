//
//  MyInfoViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/07.
//

import UIKit
import RxSwift

class MyInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  private let bag = DisposeBag()
  
  private let tier = TierToString()
  
  // MARK: ViewModel
  private var myInfoViewModel = MyInfoViewModel()
  
  // MARK: Model
  private let myInfoModel = MyInfoModel.shared
  
  // MARK: View
  private let navigationView = CustomNavigationView()
  
  private let myProfileInfoView = MyProfileInfoView()
  
  private let partition = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
  }
  
  private let myDetailProfileView = MyDetailProfileView()
  
  private let administrateTableView = UITableView(frame: .zero,
                                                  style: .grouped)
    .then {
      $0.contentInset = UIEdgeInsets(top: -CommonLength.shared.height(25), left: 0, bottom: 0, right: 0)
      $0.backgroundColor = .white
      $0.isScrollEnabled = false
      $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
  
  private let rightButtonItem = UIButton().then {
    $0.setImage(UIImage(named: "tricolon"),
                for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 19)
  }
  
  private let naviBarTitleLabel = UILabel().then {
    $0.text = "MY"
    $0.font = UIFont.joinuns.font(size: 23)
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  let myProfileEditVC = MyProfileEditViewController()
  
  // MARK: LifeCycle
  override func loadView() {
    super.loadView()
    self.myInfoViewModel = self.myProfileEditVC.myInfoViewModel
    
    self.myInfoViewModel
      .bindShowGameID()
    
    self.myInfoViewModel
      .outputShowGameID
      .bind(to: self.myProfileInfoView
              .useNickNameLabel()
              .rx
              .text)
      .disposed(by: self.bag)
    
    self.setMyProfile()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = #colorLiteral(red: 0.8783445954, green: 0.8784921765, blue: 0.8783251643, alpha: 1)
    self.administrateTableView.dataSource = self
    self.administrateTableView.delegate = self
    self.administrateTableView.register(AdministrateTableViewCell.self,
                                        forCellReuseIdentifier: AdministrateTableViewCell.ID)
    self.setupView()
    self.setNavigationBar()
    self.didTapEditProfileButton()
  }
  
  private func setupView() {
    [navigationView,
     myProfileInfoView,
     myDetailProfileView,
     partition,
     administrateTableView].forEach { self.view.addSubview($0) }
    
    navigationView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(100))
    }
    
    myProfileInfoView.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom)
      $0.width.centerX.equalToSuperview()
    }
    
    partition.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.top.equalTo(myDetailProfileView)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.9)
    }
    
    myDetailProfileView.snp.makeConstraints {
      $0.top.equalTo(myProfileInfoView.snp.bottom)
      $0.width.centerX.equalToSuperview()
    }
    
    administrateTableView.snp.makeConstraints {
      $0.top.equalTo(myDetailProfileView.snp.bottom).offset(CommonLength.shared.height(5))
      $0.width.centerX.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  private func setNavigationBar() {
    [naviBarTitleLabel, rightButtonItem].forEach { self.navigationView.addSubview($0) }
    
    naviBarTitleLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(20))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
    }
    
    rightButtonItem.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(17))
      $0.centerY.equalTo(naviBarTitleLabel)
      $0.width.equalTo(CommonLength.shared.width(20))
      $0.height.equalTo(CommonLength.shared.height(20))
    }
    
    self.navigationController?.navigationBar.isHidden = true
  }
  
  private func setMyProfile() {
    
    self.myProfileInfoView
      .useNickNameLabel()
      .text = self.myInfoModel.myGameID
    
    self.myDetailProfileView
      .useMyGameProfileView()
      .useMyTierLabel()
      .text = self.tier.toString(tier: self.myInfoModel.myTier)
    
    self.myDetailProfileView
      .useMyMannerView()
      .setMannerStatus(manner: 12)
  }
  
  private func didTapEditProfileButton() {
    CommonAction.shared.touchActionEffect(self.myProfileInfoView
                                            .userEditProfileButton()) {
      
      self.navigationController?
        .pushViewController(self.myProfileEditVC,
                            animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.myInfoModel.administrateList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let administrateCell = tableView.dequeueReusableCell(withIdentifier: AdministrateTableViewCell.ID,
                                                               for: indexPath) as? AdministrateTableViewCell else { fatalError("custom cell error") }
    
    administrateCell.selectionStyle = .none
    
    administrateCell.useTitleLabel().text = self.myInfoModel.administrateList[indexPath.row]
    
    return administrateCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    var pushVC = UIViewController()
    
    if indexPath.row == 0 {
      
      pushVC = MyFriendViewContrller()
      
    } else if indexPath.row == 1 {
      
      pushVC = MyBlackListViewController()
      
    }
    
    self.navigationController?
      .pushViewController(pushVC,
                          animated: true)
  }
}
