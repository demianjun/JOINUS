//
//  ChangeWindow.swift
//  JOINUS
//
//  Created by Demian on 2021/08/16.
//

import UIKit

class ChangeWindow {
  func change(change VC: UIViewController) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate,
        window = UIWindow(frame: UIScreen.main.bounds)
    
    window.rootViewController = VC
    window.makeKeyAndVisible()
    appDelegate.window = window
  }
}

