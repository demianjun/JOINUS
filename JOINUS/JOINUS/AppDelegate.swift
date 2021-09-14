//
//  AppDelegate.swift
//  JOINUS
//
//  Created by Demian on 2021/08/16.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import GoogleSignIn
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    
//    let tempVC = MyInfoViewController(),
//        launchVC = UINavigationController.init(rootViewController: tempVC)
    let launchVC = LaunchViewController()
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    
    self.window?.rootViewController = launchVC
    self.window?.makeKeyAndVisible()
    
    FirebaseApp.configure()
    
    // Override point for customization after application launch.
    return true
  }
  
  func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
    
    return GIDSignIn.sharedInstance.handle(url)
  }
}

