//
//  CustomRightBarButton.swift
//  JOINUS
//
//  Created by Demian on 2021/09/08.
//

import UIKit

class CustomRightBarButton: UIButton {
  
  private let filterButton = UIButton().then {
    $0.setImage(UIImage(named: "filter"),
                for: .normal)
    $0.contentMode = .scaleAspectFit
  }
  
  private let glassesButton = UIButton().then {
    $0.setImage(UIImage(named: "glasses"),
                for: .normal)
    $0.contentMode = .scaleAspectFit
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.setupView()
  }
  
  private func setupView() {
    [filterButton, glassesButton].forEach { self.addSubview($0) }
    
    filterButton.snp.makeConstraints {
      $0.width.height.equalTo(CommonLength.shared.width(22))
      $0.leading.top.bottom.equalToSuperview()
    }
    
    glassesButton.snp.makeConstraints {
      $0.width.height.equalTo(CommonLength.shared.width(22))
      $0.leading.equalTo(filterButton.snp.trailing).offset(CommonLength.shared.width(15))
      $0.trailing.top.bottom.equalToSuperview()
    }
  }
  
  func useFilterButton() -> UIButton {
    return self.filterButton
  }
  
  func useGlassesButton() -> UIButton {
    return self.glassesButton
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
