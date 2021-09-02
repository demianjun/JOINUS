//
//  JoinusActionSheetView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/02.
//

import UIKit

class JoinusActionSheetView: UIView {
  // MARK: View
  private let actionSheetView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.actionSheetGray
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
  }
  
  private let selectAlbumButton = UIButton().then {
    $0.setTitle("앨범에서 선택",
                for: .normal)
    $0.setTitleColor(UIColor.joinusColor.joinBlue,
                     for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 15)
    $0.backgroundColor = .clear
  }
  
  private let changeDefaultImageButton = UIButton().then {
    $0.setTitle("기본 이미지로 변경",
                for: .normal)
    $0.setTitleColor(UIColor.joinusColor.defaultImagePink,
                     for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 15)
    $0.backgroundColor = .clear
  }
  
  private let partitionView = UIView().then {
    $0.backgroundColor = .clear.withAlphaComponent(0.13)
  }
  
  private let cancel = UIButton().then {
    $0.setTitle("닫기",
                for: .normal)
    $0.setTitleColor(UIColor.joinusColor.joinBlue,
                     for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 15)
    $0.backgroundColor = UIColor.joinusColor.actionSheetGray
    $0.layer.cornerRadius = 10
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.setupView()
  }
  
  private func setupView() {
    [actionSheetView, cancel].forEach { self.addSubview($0) }
    [selectAlbumButton, partitionView, changeDefaultImageButton].forEach { self.actionSheetView.addSubview($0) }
    
    actionSheetView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
    }
    
    cancel.snp.makeConstraints {
      $0.top.equalTo(actionSheetView.snp.bottom).offset(CommonLength.shared.height(5))
      $0.height.equalTo(CommonLength.shared.height(50))
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    selectAlbumButton.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(50))
    }
    
    partitionView.snp.makeConstraints {
      $0.top.equalTo(selectAlbumButton.snp.bottom)
      $0.height.equalTo(0.5)
      $0.width.centerX.equalToSuperview()
    }
    
    changeDefaultImageButton.snp.makeConstraints {
      $0.top.equalTo(partitionView.snp.bottom)
      $0.bottom.width.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(50))
    }
  }
  
  func useSelectAlbumButton() -> UIButton {
    return self.selectAlbumButton
  }
  
  func useChangeDefaultImageButton() -> UIButton {
    return self.changeDefaultImageButton
  }
  
  func useCancelButton() -> UIButton {
    return self.cancel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
