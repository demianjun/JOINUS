//
//  ChattingTableViewCell.swift
//  JOINUS
//
//  Created by Demian on 2021/09/16.
//

import UIKit

class ChattingTableViewCell: UITableViewCell {
  static let ID = "ChattingTableViewCell"
  
  // MARK: View
  private let profileImageView = UIImageView()
  
  private let messageView = MessageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = .clear
    self.setupView()
  }
  
  private func setupView() {
    [profileImageView, messageView].forEach { self.addSubview($0) }
  }
  
  func useMessageView() -> MessageView {
    return self.messageView
  }
  
  func useProfileImageView() -> UIImageView {
    return self.profileImageView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
