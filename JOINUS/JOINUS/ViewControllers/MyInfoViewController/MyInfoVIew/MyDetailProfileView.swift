//
//  MyDetailProfileView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/14.
//

import UIKit

class MyDetailProfileView: UIView {
  // MARK: View
  private let myGameProfileView = MyGameProfileView()
  
  private let myMannerView = MyMannerView()
  
  private let mannerGuideView = MannerGuideView()
  
  // MARK: initialized
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.setupView()
  }
  
  private func setupView() {
    [myGameProfileView, myMannerView, mannerGuideView].forEach { self.addSubview($0) }
    
    myGameProfileView.snp.makeConstraints {
      $0.top.leading.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.5)
      $0.height.equalTo(CommonLength.shared.height(105))
    }
    
    myMannerView.snp.makeConstraints {
      $0.top.trailing.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.5)
      $0.height.equalTo(CommonLength.shared.height(105))
    }
    
    mannerGuideView.snp.makeConstraints {
      $0.top.equalTo(myGameProfileView.snp.bottom)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.height.equalTo(CommonLength.shared.height(58))
      $0.bottom.equalTo(-CommonLength.shared.height(15))
    }
  }
  
  func useMyGameProfileView() -> MyGameProfileView {
    return self.myGameProfileView
  }
  
  func useMyMannerView() -> MyMannerView {
    return self.myMannerView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
