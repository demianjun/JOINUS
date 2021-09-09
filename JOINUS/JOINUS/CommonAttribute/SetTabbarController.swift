//
//  SetTabbarController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/08.
//

import UIKit

class SetTabbarController {
  private let changeWindow = ChangeWindow()
  
  func settingRootViewController() {
    let gameListVC = HomeListViewController(),
        myMatchingVC = MyMatchingViewController(),
        myInfoVC = MyInfoViewController()
    
    let gameNaviVC = UINavigationController(rootViewController: gameListVC),
        myMatchingNaviVC = UINavigationController(rootViewController: myMatchingVC),
        myInfoNaviVC = UINavigationController(rootViewController: myInfoVC)
    
    let tabbarController = UITabBarController(),
        tabbarItems = tabbarController.tabBar
    
    tabbarController.viewControllers = [gameNaviVC, myMatchingNaviVC, myInfoNaviVC]
    
    tabbarItems.items?[0].image = UIImage(named: "home_deselect")
    tabbarItems.items?[0].selectedImage = UIImage(named: "home_select")
    
    tabbarItems.items?[1].image = UIImage(named: "myMatching_deselect")
    tabbarItems.items?[1].selectedImage = UIImage(named: "myMatching_select")

    tabbarItems.items?[2].image = UIImage(named: "myInfo_deselect")
    tabbarItems.items?[2].selectedImage = UIImage(named: "myInfo_select")
    
    tabbarItems.items?.forEach {
      $0.imageInsets = UIEdgeInsets(top: 12, left: -3, bottom: -12, right: -3)
    }
    
    tabbarItems.layer.shadowOffset = CGSize(width: 0, height: 1)
    tabbarItems.layer.shadowColor = #colorLiteral(red: 0.4509803922, green: 0.4509803922, blue: 0.4509803922, alpha: 1)
    tabbarItems.layer.shadowOpacity = 0.5
    
    UITabBar
      .appearance()
      .barTintColor = UIColor.white
    
    UITabBar
      .appearance()
      .tintColor = .black
    
    self.changeWindow
      .change(change: tabbarController)
  }
}
