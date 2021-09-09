//
//  JoinPeopleProfileView.swift
//  JOINUS
//
//  Created by Demian on 2021/09/09.
//

import UIKit

class JoinPeopleProfileCollectionView: UIView {
  
  private lazy var collectionView = UICollectionView(frame: UIScreen.main.bounds,
                                                     collectionViewLayout: self.layout).then {
      $0.backgroundColor = .clear
    }
  
  private let layout = UICollectionViewFlowLayout()

  // MARK: Initialized
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.collectionView.register(JoinProfileCell.self,
                                 forCellWithReuseIdentifier: JoinProfileCell.ID)
    self.setupView()
  }
  
  private func setupView() {
    self.flowLayout()
    [collectionView].forEach { self.addSubview($0) }
    
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func flowLayout() {
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 20
    layout.sectionInset = UIEdgeInsets(top: 0,
                                       left: 0,
                                       bottom: 0,
                                       right: 0)
//    layout.itemSize = CGSize(width: ((UIScreen.main.bounds.width * 0.75) - 40) * 0.3,
//                             height: ((UIScreen.main.bounds.width * 0.1) - 15) * 0.5)
    layout.itemSize = CGSize(width: CommonLength.shared.width(70),
                             height: CommonLength.shared.height(70))
  }
  
  func useSelectedCollectionView() -> UICollectionView {
    return self.collectionView
  }
 
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
