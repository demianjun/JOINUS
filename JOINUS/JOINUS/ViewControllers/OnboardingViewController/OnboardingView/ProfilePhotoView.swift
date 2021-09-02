//
//  ProfilePhotoView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/02.
//

import UIKit

class ProfilePhotoView: UIView {
  // MARK: View
  private let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let plusImageView = UIImageView().then {
    $0.image = UIImage(named: "group13")
    $0.contentMode = .scaleAspectFit
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  private func setupView() {
    [profileImageView, plusImageView].forEach { self.addSubview($0) }
    
    profileImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    plusImageView.snp.makeConstraints {
      $0.trailing.bottom.equalToSuperview()
      $0.width.height.equalTo(CommonLength.shared.width(30))
    }
  }
  
  func useProfileImageView() -> UIImageView {
    return self.profileImageView
  }
  
  func usePlusImageView() -> UIImageView {
    return self.plusImageView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
