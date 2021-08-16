//
//  AppDelegate.swift
//  JOINUS
//
//  Created by Demian on 2021/08/16.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let launchVC = ViewController()
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = launchVC
    self.window?.makeKeyAndVisible()
    // Override point for customization after application launch.
    return true
  }
}

