//
//  ShowMatchingJoinerViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/17.
//

import UIKit
import RxSwift

class ShowMatchingJoinerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  private let bag = DisposeBag()
  
  var joinUsersInfo = [JoinUserInfo]()
  
  private let tapGesture = UITapGestureRecognizer(),
              duration = 0.2
  
  private let backgroundView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.defaultPhotoGray
    $0.bounds = UIScreen.main.bounds
    $0.isUserInteractionEnabled = true
    $0.alpha = 0.0
  }
  
  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.clipsToBounds = true
    $0.roundCorners(cornerRadius: 10,
                    maskedCorners: [.layerMinXMinYCorner,
                                    .layerMaxXMinYCorner])
  }
  
  private let closeButton = UIButton().then {
    $0.setTitle("닫기",
                for: .normal)
    $0.setTitleColor(.black,
                     for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 17)
  }
  
  private let titleLabel = UILabel().then {
    $0.text = "이 매칭의 참여자"
    $0.font = UIFont.joinuns.font(size: 18)
    $0.textColor = .black
  }
  
  private let partition = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
  }
  
  private let matchingJoinerTableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.matchingJoinerTableView.delegate = self
    self.matchingJoinerTableView.dataSource = self
    self.matchingJoinerTableView.register(MatchingJoinerTableViewCell.self,
                                          forCellReuseIdentifier: MatchingJoinerTableViewCell.ID)
    self.setupView()
    self.didTapCancelButton()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.presentAnimation()
  }
  
  private func setupView() {
    [backgroundView, containerView].forEach { self.view.addSubview($0) }
    [titleLabel, closeButton, partition, matchingJoinerTableView].forEach { self.containerView.addSubview($0) }
    
    backgroundView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    containerView.snp.makeConstraints {
      $0.width.bottom.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(340))
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(CommonLength.shared.height(17))
      $0.centerX.equalToSuperview()
    }
    
    closeButton.snp.makeConstraints {
      $0.bottom.equalTo(titleLabel)
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(17))
      $0.width.equalTo(CommonLength.shared.width(36))
      $0.height.equalTo(CommonLength.shared.height(27))
    }
    
    partition.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.top.equalTo(titleLabel.snp.bottom).offset(CommonLength.shared.height(17))
      $0.width.centerX.equalToSuperview()
    }
    
    matchingJoinerTableView.snp.makeConstraints {
      $0.top.equalTo(partition.snp.bottom)
      $0.width.bottom.centerX.equalToSuperview()
    }
    
    self.backgroundView.addGestureRecognizer(self.tapGesture)
    self.containerView.transform = .init(translationX: 0,
                                         y: CommonLength.shared.height(400))
  }
  
  private func presentAnimation() {
    UIView.animate(withDuration: self.duration) {
      self.backgroundView.alpha = 1.0
    }
    
    UIView.animate(withDuration: self.duration) {
      self.containerView.transform = .identity
    }
  }
  
  private func dismissAnimation() {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) {
      self.dismiss(animated: false)
    }
    
    UIView.animate(withDuration: self.duration) {
      self.backgroundView.alpha = 0.0
    }
    
    UIView.animate(withDuration: self.duration) {
      self.containerView.transform = .init(translationX: 0,
                                           y: CommonLength.shared.height(400))
    }
  }
  
  private func didTapCancelButton() {
    
    self.closeButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.dismissAnimation()
        
      }).disposed(by: self.bag)
        
    self.tapGesture
      .rx
      .event
      .asDriver()
      .drive(onNext: { tap in
        
        self.dismissAnimation()
        
      }).disposed(by: self.bag)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.joinUsersInfo.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let matchingJoinerCell = tableView.dequeueReusableCell(withIdentifier: MatchingJoinerTableViewCell.ID,
                                                                 for: indexPath) as? MatchingJoinerTableViewCell else { fatalError("cell error") }
    
    let down = DownLoad(),
        userInfo = self.joinUsersInfo[indexPath.row],
        profileImage = userInfo.imageAddress
    
    matchingJoinerCell.useProfileImageView().image = down.imageURL(image: profileImage)
    matchingJoinerCell.useUserNameLabel().text = userInfo.nickName
    
    return matchingJoinerCell
  }
  
}
