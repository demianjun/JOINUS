//
//  JointChattingViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit
import RxSwift
import SwiftSocket

class JoinChattingViewController: UIViewController {
  private let bag = DisposeBag()
  
  // MARK: Model
  private let joinChattingModel = JoinChattingModel.shared
  
  // MARK: View
  private let navigationView = CustomNavigationView()
  
  private let rightButtonItem1 = UIButton().then {
    $0.setImage(UIImage(named: "tricolon"),
                for: .normal)
  }
  
  private let rightButtonItem2 = UIButton().then {
    $0.setImage(UIImage(named: "people"),
                for: .normal)
  }
  
  private let leftButtonItem = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"),
                for: .normal)
    $0.tintColor = .black
    $0.transform = .init(scaleX: 1.5, y: 1.5)
  }
  
  private let centerButtonItem = UIButton()
  
  private let naviBarTitleLabel = UILabel().then {
    $0.text = "프로필 수정"
    $0.font = UIFont.joinuns.font(size: 19)
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  private let chattingTableView = UITableView().then {
    $0.backgroundColor = .white
    $0.separatorStyle = .none
  }
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.setupView()
    self.setRoomMannerImage()
    self.setNavigationBar()
    self.popViewController()
  }
  
  private func setupView() {
    [navigationView].forEach { self.view.addSubview($0) }
    
    navigationView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(100))
    }
  }
  
  private func setNavigationBar() {
    [leftButtonItem,
     naviBarTitleLabel, centerButtonItem,
     rightButtonItem1, rightButtonItem2].forEach { self.navigationView.addSubview($0) }
    
    naviBarTitleLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(20))
      $0.centerX.equalToSuperview()
    }
    
    leftButtonItem.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
      $0.centerY.equalTo(naviBarTitleLabel)
      $0.width.height.equalTo(CommonLength.shared.width(15))
    }
    
    centerButtonItem.snp.makeConstraints {
      $0.width.height.equalTo(CommonLength.shared.width(26))
      $0.centerY.equalTo(naviBarTitleLabel)
      $0.trailing.equalTo(naviBarTitleLabel.snp.leading).offset(-CommonLength.shared.width(12))
    }
    
    rightButtonItem1.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(17))
      $0.centerY.equalTo(naviBarTitleLabel)
      $0.width.equalTo(CommonLength.shared.width(20))
      $0.height.equalTo(CommonLength.shared.height(20))
    }
    
    rightButtonItem2.snp.makeConstraints {
      $0.trailing.equalTo(rightButtonItem1.snp.leading).offset(-CommonLength.shared.width(10))
      $0.centerY.equalTo(naviBarTitleLabel)
      $0.width.equalTo(CommonLength.shared.width(25))
      $0.height.equalTo(CommonLength.shared.height(30))
    }
    
    self.navigationController?.navigationBar.isHidden = true
  }
  
  private func setRoomMannerImage() {
    var named = String()
    
    if self.joinChattingModel.selectedRoomManner <= 5 {
      
      named = "manner1_24x24"
      
    } else if self.joinChattingModel.selectedRoomManner <= 10 {
      
      named = "manner2_24x24"
      
    } else if self.joinChattingModel.selectedRoomManner <= 15 {
      
      named = "manner3_24x24"
      
    } else if self.joinChattingModel.selectedRoomManner <= 20 {
      
      named = "manner4_24x24"
    }
    
    self.centerButtonItem
      .setImage(UIImage(named: named),
                for: .normal)
  }
  
  private func popViewController() {
    self.leftButtonItem
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
      
        self.navigationController?
          .popViewController(animated: true)
        
      }).disposed(by: self.bag)
  }
}
