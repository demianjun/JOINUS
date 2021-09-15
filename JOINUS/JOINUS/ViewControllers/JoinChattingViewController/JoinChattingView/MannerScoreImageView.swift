//
//  MannerScoreImageView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit

class MannerScoreImageView: UIView {
  private let manner1ImageView = UIImageView().then {
    $0.image = UIImage(named: "manner1_24x24")
  }
  
  private let manner2ImageView = UIImageView().then {
    $0.image = UIImage(named: "manner2_24x24")
  }
  
  private let manner3ImageView = UIImageView().then {
    $0.image = UIImage(named: "manner3_24x24")
  }
  
  private let manner4ImageView = UIImageView().then {
    $0.image = UIImage(named: "manner4_24x24")
  }
  
  private let arrowImageView = UIImageView().then {
    $0.image = UIImage(named: "checkManner")
    $0.contentMode = .scaleAspectFill
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.setupView()
  }
  
  private func setupView() {
    [manner1ImageView, manner2ImageView,
     manner3ImageView, manner4ImageView,
     arrowImageView].forEach { self.addSubview($0) }
    
    manner1ImageView.snp.makeConstraints {
      $0.width.height.equalTo(CommonLength.shared.width(30))
      $0.leading.equalToSuperview()
    }
    
    manner2ImageView.snp.makeConstraints {
      $0.width.height.equalTo(CommonLength.shared.width(30))
      $0.top.equalTo(manner1ImageView)
      $0.leading.equalTo(manner1ImageView.snp.trailing).offset(CommonLength.shared.width(40))
    }
    
    manner3ImageView.snp.makeConstraints {
      $0.width.height.equalTo(CommonLength.shared.width(30))
      $0.top.equalTo(manner1ImageView)
      $0.leading.equalTo(manner2ImageView.snp.trailing).offset(CommonLength.shared.width(40))
    }
    
    manner4ImageView.snp.makeConstraints {
      $0.width.height.equalTo(CommonLength.shared.width(30))
      $0.top.equalTo(manner1ImageView)
      $0.leading.equalTo(manner3ImageView.snp.trailing).offset(CommonLength.shared.width(40))
      $0.trailing.equalTo(arrowImageView)
    }
    
    arrowImageView.snp.makeConstraints {
      $0.width.centerX.bottom.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
