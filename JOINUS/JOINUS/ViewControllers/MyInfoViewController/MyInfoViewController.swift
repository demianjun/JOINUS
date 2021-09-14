//
//  MyInfoViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/07.
//

import UIKit
import RxSwift

class MyInfoViewController: UIViewController {
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
    self.setupView()
    self.setNavigationBar()
    self.didTapEditProfileButton()
  }
  
  private func setupView() {
    [navigationView,
     myProfileInfoView,
     myDetailProfileView,
     partition].forEach { self.view.addSubview($0) }
    
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
    
//    self.myInfoModel.myGameID = "PreyIOS"
    
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
}
