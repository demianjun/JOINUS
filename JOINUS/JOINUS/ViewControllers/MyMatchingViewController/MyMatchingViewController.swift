//
//  MyMatchingViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/07.
//

import UIKit
import RxSwift

class MyMatchingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
  private let bag = DisposeBag()
  
  private let methods = CalculateAboutTime()
  
  // MARK: Manager
  private let service = Service.manager
  
  // MARK: Model
  private let myMatchingModel = MyMatchingModel.shared
  
  // MARK: View
  private let joinedMatchingButton = MatchinTypeButton(type: "참여한 매칭")

  private let madeMatchingButton = MatchinTypeButton(type: "내가 만든 매칭")
  
  private let matchingTableView = UITableView().then {
    $0.backgroundColor = .white
  }
  
  private let noCountJoinedImageView = NoCountImageView(type: .joined).then {
    $0.isHidden = true
  }
  
  private let noCountMadeImageView = NoCountImageView(type: .made).then {
    $0.isHidden = true
  }
  
  private let refresh = UIRefreshControl().then {
    $0.tintColor = UIColor.joinusColor.joinBlue
    $0.attributedTitle = NSAttributedString(string: "",
                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.joinusColor.joinBlue,
                                                         NSAttributedString.Key.font : UIFont.joinuns.font(size: 13)])
  }
  
  // MARK: Life Cycle
  override func loadView() {
    super.loadView()
    self.myMatchingModel
      .myMatchingTableView = self.matchingTableView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.matchingTableView.delegate = self
    self.matchingTableView.dataSource = self
    self.matchingTableView.register(JoinusCustomCell.self,
                                    forCellReuseIdentifier: JoinusCustomCell.ID)
    self.joinedMatchingButton.isSelected = true
    
    self.service
      .getJoinedMatching {
        
        self.setupView()
      }
    
    self.buttonsStatus()
    self.didTapJoinedMatchingButton()
    self.didTapMadeMatchingButton()
  }
  
  private func setupView() {
    [joinedMatchingButton, madeMatchingButton,
     matchingTableView,
     noCountMadeImageView, noCountJoinedImageView].forEach { self.view.addSubview($0) }
    
    joinedMatchingButton.snp.makeConstraints {
      $0.top.leading.equalTo(self.view.safeAreaLayoutGuide)
      $0.width.equalToSuperview().multipliedBy(0.5)
    }
    
    madeMatchingButton.snp.makeConstraints {
      $0.top.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.width.equalToSuperview().multipliedBy(0.5)
    }
    
    matchingTableView.snp.makeConstraints {
      $0.top.equalTo(joinedMatchingButton.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    noCountJoinedImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    noCountMadeImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    if self.myMatchingModel.matchingList.isEmpty {
      
      self.matchingTableView.isHidden = true
      self.noCountJoinedImageView.isHidden = false
      self.noCountMadeImageView.isHidden = true
      
    }
    
    self.navigationController?.navigationBar.isHidden = true
  }
  
  private func buttonsStatus() {
    enum type {
      case joined, made
    }
    
    Observable.of(self.joinedMatchingButton.rx.tap.map { type.joined },
                  self.madeMatchingButton.rx.tap.map { type.made })
      .merge()
      .asDriver(onErrorJustReturn: .joined)
      .drive { type in
        
        switch type {
          case .joined:
            
            self.joinedMatchingButton.isSelected = true
            self.madeMatchingButton.isSelected = false
            
          case .made:
            
            self.joinedMatchingButton.isSelected = false
            self.madeMatchingButton.isSelected = true
        }
        
      }.disposed(by: self.bag)
  }
  
  private func didTapJoinedMatchingButton() {
    self.joinedMatchingButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.service
          .getJoinedMatching {
            
            if self.myMatchingModel.matchingList.isEmpty {
              
              self.matchingTableView.isHidden = true
              self.noCountJoinedImageView.isHidden = false
              self.noCountMadeImageView.isHidden = true
              
            } else {
              
              self.matchingTableView.isHidden = false
              self.noCountJoinedImageView.isHidden = true
              self.noCountMadeImageView.isHidden = true
              
            }
        }
        
      }).disposed(by: self.bag)
  }
  
  private func didTapMadeMatchingButton() {
    self.madeMatchingButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.service
          .getMadeMatching {
            
            if self.myMatchingModel.matchingList.isEmpty {
              
              self.matchingTableView.isHidden = true
              self.noCountJoinedImageView.isHidden = true
              self.noCountMadeImageView.isHidden = false
              
            } else {
              
              self.matchingTableView.isHidden = false
              self.noCountJoinedImageView.isHidden = true
              self.noCountMadeImageView.isHidden = true
              
            }
        }
        
      }).disposed(by: self.bag)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.myMatchingModel.matchingList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let gameListCell = tableView.dequeueReusableCell(withIdentifier: JoinusCustomCell.ID,
                                                           for: indexPath) as? JoinusCustomCell else { fatalError("custom cell return") }
    
    gameListCell.selectionStyle = .none
    
    let temp = self.myMatchingModel.matchingList[indexPath.row],
        createdAt = temp.createdAt,
        startDate = temp.startDate,
        createdInterval = self.methods.calculateCreatedTime(created: createdAt),
        startInterval = self.methods.calculateStartTime(start: startDate),
        leaderPk = temp.leaderPk,
        peopleCount = temp.nowPeopleCnt,
        peopleNum = temp.peopleNumber
    
    var joinJangID = String()
    
    self.myMatchingModel.matchingList[indexPath.row].userList.forEach {
          
          if leaderPk == $0.pk {
            joinJangID = $0.nickName
          }
        }

    if startInterval.contains("완료") {
      
      gameListCell.useStartLabel().backgroundColor = UIColor.joinusColor.gameIdTextFieldBgGray
      gameListCell.useStartLabel().textColor = UIColor.joinusColor.gameIdTextFieldPlaceholderGray
      
    } else {
      
      gameListCell.useStartLabel().backgroundColor = UIColor.joinusColor.defaultPhotoGray
      gameListCell.useStartLabel().textColor = .white
    }
    
    if (createdInterval == "방금 전") ||
       (createdInterval == "1분 전") ||
       (createdInterval == "2분 전") ||
       (createdInterval == "3분 전") ||
       (createdInterval == "4분 전") ||
       (createdInterval == "5분 전") {
        
        gameListCell.useNewLabel().isHidden = false
      
    } else {
      
      gameListCell.useNewLabel().isHidden = true
    }
    
    gameListCell.useJoinJangLabel().text = joinJangID
    gameListCell.useTitleLabel().text = temp.roomName
    gameListCell.usePersonCountLabel().text = "\(peopleCount)/\(peopleNum)"
    gameListCell.useStartLabel().text = startInterval
    gameListCell.useCreatedTimeLabel().text = createdInterval
    
    return gameListCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let roomInfo = self.myMatchingModel.matchingList[indexPath.row],
        joinPeopleNum = roomInfo.userList.count
    
    let selectJoinGameVC = SelectJoinGameViewController(roomInfo: roomInfo)

    let joinButton = selectJoinGameVC.useJoinButton(),
        joinGameView = selectJoinGameVC.useJoinGameView(),
        voiceChatCheck = joinGameView.useVoiceChatCheck(),
        joinGameCollectionView = joinGameView.useJoinPeopleProfileCollectionView()
    
    joinButton.setTitle("방 수정하기",
                        for: .normal)
   
    joinGameCollectionView.snp.makeConstraints {
      $0.top.equalTo(voiceChatCheck.snp.bottom).offset(CommonLength.shared.height(22))
      $0.height.equalTo(CommonLength.shared.height(70))
      $0.width.equalTo(CommonLength.shared.width(70) * CGFloat(joinPeopleNum) + 10)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(22))
    }
    
    self.navigationController?.pushViewController(selectJoinGameVC, animated: true)
//    let naviVC = self.tabBarController?.customizableViewControllers?[0] as? UINavigationController
//    naviVC?.pushViewController(selectJoinGameVC, animated: true)
  }
}
