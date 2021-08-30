//
//  LoginViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/08/17.
//

import UIKit
import GoogleSignIn
import RxSwift
import Alamofire
import Firebase

class LoginViewController: UIViewController {
  private let bag = DisposeBag()
  
  private let changeWindow = ChangeWindow()
  
  private let signInConfig = GIDConfiguration.init(clientID: "1012388240225-lmalqape8ejnija8rab1g5rde2f2g2p2.apps.googleusercontent.com")
  
  // MARK: View
  private let googleLoginButton = GIDSignInButton().then {
    $0.colorScheme = .light
    $0.style = .wide
  }
  
  private let loginButton = UIButton().then {
    $0.setTitle("구글로 시작하기",
                for: .normal)
    $0.setTitleColor(.black,
                     for: .normal)
    $0.titleLabel?.font = UIFont.joinuns.font(size: 17)
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 4
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = true
    self.view.backgroundColor = UIColor.joinusColor.joinBlue
    self.setupUI()
    self.didTapButtonAction()
//    self.googleLoginButton.addTarget(self,
//                                     action: #selector(buttonAction(_:)),
//                                     for: .touchUpInside)
  }
  
  private func setupUI() {
   
//    [googleLoginButton].forEach { self.view.addSubview($0) }
//
//    googleLoginButton.snp.makeConstraints {
//      $0.center.equalToSuperview()
//    }
    
    [loginButton].forEach { self.view.addSubview($0) }
    
    loginButton.snp.makeConstraints {
      $0.width.equalToSuperview().multipliedBy(0.7)
      $0.height.equalTo(CommonLength.shared.height(35))
      $0.center.equalToSuperview()
    }
  }
  
  func didTapButtonAction() {
    
    let onBoardingVC = OnboardingViewController(),
        onBoardingNaviVC = UINavigationController(rootViewController: onBoardingVC)
    
    CommonAction.shared.touchActionEffect(self.loginButton) {
      
      self.changeWindow.change(change: onBoardingNaviVC)
    }
  }
  
  @objc private func buttonAction(_ sender: UIButton) {
   
    GIDSignIn.sharedInstance.signIn(with: self.signInConfig,
                                    presenting: self) { user, err in
      
      if let err = err {
        
        print("login" + err.localizedDescription)
        
      } else {
        
//        guard let token = user?.authentication.accessToken else { return }
        guard let token = user?.authentication.idToken else { return }
        print("-> user: \(user?.authentication.clientID)")
        print("-> user token: \(token)")
        self.signUp(token: token)
      }
    }
  }
  
  func signUp(token: String) {
    let url = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/login?" + "code=" + token

    print("-> url: \(url)")
    AF.request(url,
               method: .get)
      .validate(statusCode: 150..<800)
      .responseJSON {
        
        switch $0.result {
          case .success(let res):
            do {
              let temp = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted),
                  data = try JSONDecoder().decode(Get.self, from: temp)
              
              print(data)
              
            } catch(let err) {
              
              print(err.localizedDescription + "-> 1")
            }
            
          case .failure(let err):
            
            print(err.localizedDescription + "-> 2")
        }
      }
  }
}

extension LoginViewController {
  
  struct Get: Decodable {
    var age = Int(),
        firebaseToken = String(),
        gender = Int(),
        imageAddress = String(),
        nickName = String(),
        pk = Int(),
        token = String()
    
    enum CodingKeys: String, CodingKey {
      case age, gender, pk, token
      case firebaseToken = "firebase_token", imageAddress = "image_address", nickName = "nickname"
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      
      age = try container.decode(Int.self,
                                 forKey: .age)
      
      firebaseToken = try container.decode(String.self,
                                           forKey: .firebaseToken)
      
      gender = try container.decode(Int.self,
                                    forKey: .gender)
      
      imageAddress = try container.decode(String.self,
                                          forKey: .imageAddress)
      
      nickName = try container.decode(String.self,
                                      forKey: .nickName)
      
      pk = try container.decode(Int.self,
                                forKey: .pk)
      
      token = try container.decode(String.self,
                                   forKey: .token)
    }
  }
}

