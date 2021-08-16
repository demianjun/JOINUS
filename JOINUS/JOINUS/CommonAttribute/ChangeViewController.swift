//
//  ChangeViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/08/16.
//

import UIKit

class ChangeViewController: NSObject {
  
  // MARK: ViewController 전환
  func dismissAndPresentViewController(dismissVC: UIViewController,
                                       dismissAnimate: Bool? = nil,
                                       presentVC: UIViewController,
                                       presentAnimate: Bool? = nil,
                                       presentStyle: UIModalPresentationStyle? = nil,
                                       completion: (()->())? = nil) {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    dismissVC
      .view
      .window?
      .rootViewController?
      .dismiss(animated: dismissAnimate ?? false) {
      
      presentVC
        .modalPresentationStyle = presentStyle ?? .fullScreen
        
      appDelegate
        .window?
        .rootViewController?
        .present(presentVC,
                 animated: presentAnimate ?? false) {
         
          completion?()
        }
    }
  }
}
