//
//  MyFriendTableCell.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit

class AdministrateTableViewCell: UITableViewCell {
  static let ID = "MyFriendTableViewCell"
  
  private let titleLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 16)
    $0.textColor = .black
  }
  
  private let accessoryImageView = UIImageView().then {
    $0.image = UIImage(named: "vector33")
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = .white
    self.setupView()
  }
  
  private func setupView() {
    [titleLabel, accessoryImageView].forEach { self.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(15))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(20))
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(15))
    }
    
    accessoryImageView.snp.makeConstraints {
      $0.width.equalTo(CommonLength.shared.width(10))
      $0.height.equalTo(CommonLength.shared.height(15))
      $0.centerY.equalToSuperview()
      $0.trailing.equalTo(-CommonLength.shared.width(20))
    }
  }
  
  func useTitleLabel() -> UILabel {
    return self.titleLabel
  }
  
  func useAccessoryImageView() -> UIImageView {
    return self.accessoryImageView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
