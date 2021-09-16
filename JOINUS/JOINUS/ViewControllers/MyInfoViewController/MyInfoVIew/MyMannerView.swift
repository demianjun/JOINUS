//
//  MyMannerView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/14.
//

import UIKit

class MyMannerView: UIView {
  // MARK: View
  private let titleLabel = UILabel().then {
    $0.text = "매너도"
    $0.font = UIFont.joinuns.font(size: 15)
    $0.textColor = .black
  }
  
  private let myMannerImageView_1 = UIImageView()
  
  private let myMannerImageView_2 = UIImageView()
  
  private let myMannerImageView_3 = UIImageView()
  
  private let myMannerImageView_4 = UIImageView()
  
  // MARK: initialized
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.setupView()
  }
  
  private func setupView() {
    [titleLabel,
     myMannerImageView_1,
     myMannerImageView_2,
     myMannerImageView_3,
     myMannerImageView_4].forEach { self.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.leading.equalTo(CommonLength.shared.width(17))
    }
    
    myMannerImageView_1.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(CommonLength.shared.height(22))
      $0.leading.equalTo(titleLabel)
      $0.width.height.equalTo(CommonLength.shared.width(24))
    }
    
    myMannerImageView_2.snp.makeConstraints {
      $0.top.equalTo(myMannerImageView_1)
      $0.leading.equalTo(myMannerImageView_1.snp.trailing).offset(CommonLength.shared.width(15))
      $0.width.height.equalTo(CommonLength.shared.width(24))
    }
    
    myMannerImageView_3.snp.makeConstraints {
      $0.top.equalTo(myMannerImageView_1)
      $0.leading.equalTo(myMannerImageView_2.snp.trailing).offset(CommonLength.shared.width(15))
      $0.width.height.equalTo(CommonLength.shared.width(24))
    }
    
    myMannerImageView_4.snp.makeConstraints {
      $0.top.equalTo(myMannerImageView_1)
      $0.leading.equalTo(myMannerImageView_3.snp.trailing).offset(CommonLength.shared.width(15))
      $0.width.height.equalTo(CommonLength.shared.width(24))
    }
  }
  
  func useManner_1_ImageView() -> UIImageView {
    return self.myMannerImageView_1
  }
  
  func useManner_2_ImageView() -> UIImageView {
    return self.myMannerImageView_2
  }
  
  func useManner_3_ImageView() -> UIImageView {
    return self.myMannerImageView_3
  }
  
  func useManner_4_ImageView() -> UIImageView {
    return self.myMannerImageView_4
  }
  
  func setMannerStatus(manner score: Int) {
    if score < -4 {
      
      self.myMannerImageView_1.image = UIImage(named: "manner1_24x24")
      self.myMannerImageView_2.image = UIImage(named: "manner2_24x24@30")
      self.myMannerImageView_3.image = UIImage(named: "manner3_24x24@30")
      self.myMannerImageView_4.image = UIImage(named: "manner4_24x24@30")
      
    } else if score < 1 {
      
      self.myMannerImageView_1.image = UIImage(named: "manner1_24x24@30")
      self.myMannerImageView_2.image = UIImage(named: "manner2_24x24")
      self.myMannerImageView_3.image = UIImage(named: "manner3_24x24@30")
      self.myMannerImageView_4.image = UIImage(named: "manner4_24x24@30")
      
    } else if score < 6 {
      
      self.myMannerImageView_1.image = UIImage(named: "manner1_24x24@30")
      self.myMannerImageView_2.image = UIImage(named: "manner2_24x24@30")
      self.myMannerImageView_3.image = UIImage(named: "manner3_24x24")
      self.myMannerImageView_4.image = UIImage(named: "manner4_24x24@30")
      
    } else if score >= 6 {
      
      self.myMannerImageView_1.image = UIImage(named: "manner1_24x24@30")
      self.myMannerImageView_2.image = UIImage(named: "manner2_24x24@30")
      self.myMannerImageView_3.image = UIImage(named: "manner3_24x24@30")
      self.myMannerImageView_4.image = UIImage(named: "manner4_24x24")
      
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
