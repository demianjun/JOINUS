//
//  SelectTierButton.swift
//  JOINUS
//
//  Created by Demian on 2021/08/31.
//

import UIKit

class SelectTierButton: UIButton {
  
  override var isSelected: Bool {
    didSet {
      self.greenView.isHidden = !self.isSelected
      self.selectImageView.isHidden = !self.isSelected
    }
  }
  
  // MARK: View
  private let tierImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
  }
  
  private let selectImageView = UIImageView().then {
    $0.image = UIImage(named: "vector5")
    $0.contentMode = .scaleAspectFit
    $0.isHidden = true
  }
  
  private let greenView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameSelectGreen
    $0.layer.cornerRadius = CommonLength.shared.width(40) / 2
    $0.isHidden = true
  }
  
  private let tierLabel = UILabel().then {
    $0.font = UIFont.joinuns.font(size: 14)
    $0.textColor = UIColor.joinusColor.tierGray
  }
  
  init(tier: OnboardingModel.myTier) {
    super.init(frame: .zero)
    self.setupView()
    self.setTierButtonImage(tier: tier)
    self.setTierTitle(tier: tier)
  }
  
  private func setupView() {
    [tierImageView, greenView, selectImageView, tierLabel].forEach { self.addSubview($0) }
    
    tierImageView.snp.makeConstraints {
      $0.top.centerX.equalToSuperview()
      $0.width.height.equalTo(CommonLength.shared.width(40))
    }
    
    greenView.snp.makeConstraints {
      $0.top.centerX.equalToSuperview()
      $0.width.height.equalTo(CommonLength.shared.width(40))
    }
    
    selectImageView.snp.makeConstraints {
      $0.center.equalTo(greenView)
      $0.width.height.equalTo(CommonLength.shared.width(15))
    }
    
    tierLabel.snp.makeConstraints {
      $0.top.equalTo(tierImageView.snp.bottom).offset(CommonLength.shared.height(5))
      $0.centerX.equalTo(tierImageView)
      $0.bottom.equalToSuperview()
    }
  }
  
  func setTierButtonImage(tier: OnboardingModel.myTier) {
    self.tierImageView.image = UIImage(named: tier.rawValue)
  }
  
  func setTierTitle(tier: OnboardingModel.myTier) {
    var title = String()
    
    switch tier {
      case .iron:
        title = "?????????"
      case .bronze:
        title = "?????????"
      case .silver:
        title = "??????"
      case .gold:
        title = "??????"
      case .platinum:
        title = "????????????"
      case .diamond:
        title = "?????????"
      case .master:
        title = "?????????"
      case .challenger:
        title = "?????????"
    }
    
    self.tierLabel.text = title
  }
  
  func useTierImageView() -> UIImageView {
    return self.tierImageView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
