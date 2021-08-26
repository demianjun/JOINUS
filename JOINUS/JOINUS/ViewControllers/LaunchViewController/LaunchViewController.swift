//
//  ViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/08/16.
//

import UIKit

class LaunchViewController: UIViewController {
  
  // MARK: CommonAttributte
  
  
  // MARK: View
  private let symbolImage = UIImageView()
  
  private let logoLable = UILabel().then {
    $0.text = "JOINUS"
    $0.font = UIFont.joinuns.font(size: 50)
  }
  
  private let backGroundView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.joinBlue
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.joinusColor.joinBlue
    self.setupUI()
    self.changeLoginVC()
  }
  
  private func setupUI() {
    
    [backGroundView, logoLable].forEach { self.view.addSubview($0) }
    
    backGroundView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    logoLable.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  let changeVC = ChangeViewController()
  
  private func changeLoginVC() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      let loginVC = LoginViewController()
      
      self.changeVC
        .dismissAndPresentViewController(dismissVC: self,
                                         dismissAnimate: false,
                                         presentVC: loginVC,
                                         presentAnimate: false)
    }
  }
}

