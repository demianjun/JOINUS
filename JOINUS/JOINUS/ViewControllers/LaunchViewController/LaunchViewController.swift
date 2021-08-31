//
//  ViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/08/16.
//

import UIKit

class LaunchViewController: UIViewController {
  
  private let changeVC = ChangeViewController()
  
  
  // MARK: View
  private let symbolImageView = UIImageView().then {
    $0.image = UIImage(named: "invalidName")
    $0.contentMode = .scaleAspectFit
  }
  
  private let logoImageView = UIImageView().then {
    $0.image = UIImage(named: "invalidName-1")
    $0.contentMode = .scaleAspectFit
  }
  
  private let backGroundView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.joinBlue
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = true
    self.view.backgroundColor = UIColor.joinusColor.joinBlue
    self.setupUI()
    self.changeLoginVC()
  }
  
  private func setupUI() {
    
    [backGroundView, symbolImageView, logoImageView].forEach { self.view.addSubview($0) }
    
    backGroundView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    symbolImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(self.view.snp.centerY)
      $0.width.equalTo(CommonLength.shared.width(100))
      $0.height.equalTo(CommonLength.shared.height(62))
    }
    
    logoImageView.snp.makeConstraints {
      $0.top.equalTo(symbolImageView.snp.bottom).offset(CommonLength.shared.height(10))
      $0.centerX.equalToSuperview()
      $0.width.equalTo(CommonLength.shared.width(100))
      $0.height.equalTo(CommonLength.shared.height(20))
    }
  }
  
  private func changeLoginVC() {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      let loginVC = LoginViewController(),
          loginNaviVC = UINavigationController(rootViewController: loginVC)
      
      self.changeVC
        .dismissAndPresentViewController(dismissVC: self,
                                         dismissAnimate: false,
                                         presentVC: loginNaviVC,
                                         presentAnimate: false)
    }
  }
}

