//
//  SelectTierOfJoinPeopleViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/12.
//

import UIKit
import RxSwift

class SelectTierOfJoinPeopleViewController: UIViewController {
  private let bag = DisposeBag()
  
  // MARK: View
  private let navigationView = CustomNavigationView()
  
  private let selectTierOfJoinPeopleScrollView = SelectTierOfJoinPeopleScrollView()
  
  private let leftButtonItem = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"),
                for: .normal)
    $0.tintColor = .black
    $0.transform = .init(scaleX: 1.5, y: 1.5)
  }
  
  private let naviBarTitleLabel = UILabel().then {
    $0.text = "참가자 티어"
    $0.font = UIFont.joinuns.font(size: 19)
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  // MARK: initialized
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = #colorLiteral(red: 0.8783445954, green: 0.8784921765, blue: 0.8783251643, alpha: 1)
    self.setupView()
    self.setNavigationBar()
  }
  
  private func setupView() {
    [navigationView, selectTierOfJoinPeopleScrollView].forEach { self.view.addSubview($0) }
    
    navigationView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(100))
    }
    
    selectTierOfJoinPeopleScrollView.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom).offset(1)
      $0.width.centerX.bottom.equalToSuperview()
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
    
    self.navigationController?.navigationBar.isHidden = true
  }
}
