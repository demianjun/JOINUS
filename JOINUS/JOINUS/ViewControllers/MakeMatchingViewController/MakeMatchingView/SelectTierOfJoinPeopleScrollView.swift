//
//  SelectTierOfJoinPeopleScrollView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/12.
//

import UIKit

class SelectTierOfJoinPeopleScrollView: UIScrollView {
  // MARK: View
  private let smallestTierRangeView = TierRangeView(title: "최소 티어")
  
  private let largestTierRangeView = TierRangeView(title: "최대 티어")
  
  // MARK: initalized
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  private func setupView() {
    [smallestTierRangeView, largestTierRangeView].forEach { self.addSubview($0) }
    
    smallestTierRangeView.snp.makeConstraints {
      $0.top.width.centerX.equalToSuperview()
    }
    
    largestTierRangeView.snp.makeConstraints {
      $0.top.equalTo(smallestTierRangeView.snp.bottom).offset(CommonLength.shared.height(5))
      $0.width.centerX.bottom.equalToSuperview()
    }
  }
  
  func useSmallestTierRangeView() -> TierRangeView {
    return self.smallestTierRangeView
  }
  
  func useLargestTierRangeView() -> TierRangeView {
    return self.largestTierRangeView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
