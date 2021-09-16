//
//  JoinGameListLabel.swift
//  JOINUS
//
//  Created by Demian on 2021/09/09.
//

import UIKit

class JoinGameListLabel: UIView {
  // MARK: View
  private let listTitleLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 17)
    $0.textColor = .black
  }
  
  private let listContentLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 17)
    $0.textColor = UIColor.joinusColor.defaultPhotoGray
  }
  
  init(title: String) {
    super.init(frame: .zero)
    self.listTitleLabel.text = title
    self.backgroundColor = .clear
    self.setupView()
  }
  
  private func setupView() {
    [listTitleLabel, listContentLabel].forEach { self.addSubview($0) }
    
    listTitleLabel.snp.makeConstraints {
      $0.top.centerY.leading.bottom.equalToSuperview()
    }
    
    listContentLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(listTitleLabel.snp.trailing).offset(CommonLength.shared.width(13))
    }
  }
  
  func useListContentLabel() -> UILabel {
    return self.listContentLabel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
