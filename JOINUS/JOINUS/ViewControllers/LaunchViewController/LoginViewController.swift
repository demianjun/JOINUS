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
  
  private let googleConnction = GIDSignIn.sharedInstance
  
//  private let service = Service.manager
  
  private let login = LoginService.manager,
              game = GameService.manager
  
  private let myInfoModel = MyInfoModel.shared,
              messagingModel = MessagingModel.shared
  
  // MARK: View
  private let symbolImageView = UIImageView().then {
    $0.image = UIImage(named: "invalidName")
    $0.contentMode = .scaleAspectFit
  }
  
  private let loginLogoView = LoginLogoView()
  
  private let googleLoginButton = GoogleLoginButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = true
    self.view.backgroundColor = UIColor.joinusColor.joinBlue
    
    self.setupUI()
    self.didTapButtonAction()
  }
  
  private func setupUI() {
    
    [symbolImageView, loginLogoView, googleLoginButton].forEach { self.view.addSubview($0) }
    
    symbolImageView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(CommonLength.shared.height(100))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(21))
      $0.width.equalTo(CommonLength.shared.width(100))
      $0.height.equalTo(CommonLength.shared.height(62))
    }
    
    loginLogoView.snp.makeConstraints {
      $0.top.equalTo(symbolImageView.snp.bottom).offset(CommonLength.shared.height(55))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(21))
      $0.width.equalTo(CommonLength.shared.width(170))
    }
    
    googleLoginButton.snp.makeConstraints {
      $0.top.equalTo(loginLogoView.snp.bottom).offset(CommonLength.shared.height(105))
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(CommonLength.shared.height(50))
    }
  }
  
  func didTapButtonAction() {
    
    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
    let config = GIDConfiguration(clientID: clientID)

    CommonAction.shared.touchActionEffect(self.googleLoginButton) {

      GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in

        if let error = error {
          print(error.localizedDescription + "google login error")
          return
        }

        guard let authentication = user?.authentication else { return print("token return") }

        print("-> access token: \(authentication.accessToken)")
        
        self.login.signUp(accessToken: authentication.accessToken) { isLogin in
            
            if isLogin {
              
              self.game.getGame() {
              
                let setTabbarController = SetTabbarController()
                setTabbarController.settingRootViewController()
              }
            } else {
              
              let onBoardingVC = OnboardingStep1ViewController(),
                  onBoardingNaviVC = UINavigationController(rootViewController: onBoardingVC)
              
              self.changeWindow
                .change(change: onBoardingNaviVC)
            }
        }
      }
    }
  }
}
  
