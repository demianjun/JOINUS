//
//  AppDelegate.swift
//  JOINUS
//
//  Created by Demian on 2021/08/16.
//

import UIKit
import SnapKit
import Then
import GoogleSignIn
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let launchVC = LaunchViewController()
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = launchVC
    self.window?.makeKeyAndVisible()
    
    GIDSignIn.sharedInstance.restorePreviousSignIn { user, err in
      
      if err != nil || user == nil {
        
        print("log in user: \(user)")
        
      } else {
        
      }
    }
    // Override point for customization after application launch.
    return true
  }
  
  func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
    
    var handled: Bool
    
    handled = GIDSignIn.sharedInstance.handle(url)
    
    if handled {
      
      return true
      
    } else {
      
      return false
      
    }
  }
}

