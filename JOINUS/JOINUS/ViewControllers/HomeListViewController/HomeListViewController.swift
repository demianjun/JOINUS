//
//  GameListViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/07.
//

import UIKit
import RxSwift

class HomeListViewController: UIViewController {
  
  // MARK: Manager
  private let service = Service.manager
  
  // MARK: View
  private let titleButtonItem = UIBarButtonItem().then {
    $0.title = "리그오브레전드"
    $0.image = UIImage(named: "vector18")
    $0.imageInsets = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
  }
  
  private let fillterButtonItem = UIBarButtonItem(image: UIImage(systemName: "group34"),
                                                  style: .plain,
                                                  target: nil,
                                                  action: nil)
  
  private let searchButtonItem = UIBarButtonItem(image: UIImage(systemName: "layer1"),
                                                 style: .plain,
                                                 target: nil,
                                                 action: nil)

  private let joinusListTableView = UITableView()
  
  
  private let creatMatchingRoomButton = UIButton()
  
  override func loadView() {
    super.loadView()
    self.service
      .getHomeListInfo()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    self.setupUI()
  }
  
  private func setupUI() {
    
  }
  
  private func setNavigationBar() {
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationController?.navigationBar.topItem?.title = ""
    self.navigationItem.leftBarButtonItem = self.titleButtonItem
    self.navigationItem.rightBarButtonItems = [self.fillterButtonItem, self.searchButtonItem]
  }
}
