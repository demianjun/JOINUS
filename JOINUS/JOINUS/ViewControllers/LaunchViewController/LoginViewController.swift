//
//  LoginViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/08/17.
//

import UIKit
import GoogleSignIn
import RxSwift

class LoginViewController: UIViewController {
  private let bag = DisposeBag()
  
  private let signInConfig = GIDConfiguration.init(clientID: "1012388240225-lmalqape8ejnija8rab1g5rde2f2g2p2.apps.googleusercontent.com")
  
  // MARK: View
  private let googleLoginButton = GIDSignInButton().then {
    $0.colorScheme = .light
    $0.style = .wide
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.joinusColor.joinBlue
    self.setupUI()
    self.googleLoginButton.addTarget(self,
                                     action: #selector(buttonAction(_:)),
                                     for: .touchUpInside)
  }
  
  private func setupUI() {
   
    [googleLoginButton].forEach { self.view.addSubview($0) }
    
    googleLoginButton.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  @objc private func buttonAction(_ sender: UIButton) {
    
    GIDSignIn.sharedInstance.signIn(with: self.signInConfig,
                                    presenting: self) { user, err in
      
      if let err = err {
        
        print("login" + err.localizedDescription)
        
      } else {
       
        print("user email: \(user?.profile?.email)")
        print("user name: \(user?.profile?.name)")
        print("user token: \(user?.authentication.accessToken)")
        print("user: \(user?.authentication.clientID)")
        
      }
    }
  }
}

/*

 */
