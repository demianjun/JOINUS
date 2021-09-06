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
    
//    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//    let config = GIDConfiguration(clientID: clientID)
//
//    CommonAction.shared.touchActionEffect(self.googleLoginButton) {
//
//      GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
//
//        if let error = error {
//
//          print(error.localizedDescription + "google login error")
//
//          return
//        }
//
//        guard let authentication = user?.authentication,
//              let idToken = authentication.idToken else { return print("token return") }
//
//        print("access token: \(authentication.accessToken)")
//        print("id token: \(idToken)")
//        self.signUp(token: idToken)
//        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                       accessToken: authentication.accessToken)
//
//        Auth.auth().signIn(with: credential) { res, err in
//
//          if let err = err {
//            print(err.localizedDescription + "login err")
//            return
//
//          } else {
//
//            let uid = (res?.user.uid) ?? ""
//            let email = (res?.user.email) ?? ""
//
//          }
//        }
//      }
//    }
    
    let onBoardingVC = OnboardingStep1ViewController(),
        onBoardingNaviVC = UINavigationController(rootViewController: onBoardingVC)

    CommonAction.shared.touchActionEffect(self.googleLoginButton) {

      self.signUp(token: "")

      self.changeWindow
        .change(change: onBoardingNaviVC)
    }
  }
  
  func signUp(token: String) {
    //client_id : 139499651998-5mhlkgtpjgmlfbu4evd6i6a7oarrisdu.apps.googleusercontent.com
    //    let url = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com/notification/data"
    
    let url = "http://ec2-3-128-67-103.us-east-2.compute.amazonaws.com:80/api/login?" + "code=" + token
    
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
  
  //  func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
  //    if error != nil {
  //      print(error.localizedDescription)
  //    }
  //    else {
  //      let idToken = auth.parameters.objectForKey("id_token")
  //      credentialsProvider.logins = [AWSCognitoLoginProviderKey.Google.rawValue: idToken!]
  //    }
  //  }
  //}
}
  
extension LoginViewController {
  
  struct Get: Codable {
    
    var age: Int?,
        gender: Int?,
        pk: Int?,
        firebaseToken: String?,
        imageAddress: String?,
        nickName: String?,
        token: String?,
        login: Bool?
    
    enum CodingKeys: String, CodingKey {
      case age, gender, pk, token, login
      case firebaseToken = "firebase_token", imageAddress = "image_address", nickName = "nickname"
    }
  }
}
//  struct Get: Decodable {
//
//    var age: Int?,
//        gender: Int?,
//        pk: Int?,
//        firebaseToken: String?,
//        imageAddress: String?,
//        nickName: String?,
//        token: String?,
//        login: Bool?
//
//    enum CodingKeys: String, CodingKey {
//      case age, gender, pk, token, login
//      case firebaseToken = "firebase_token", imageAddress = "image_address", nickName = "nickname"
//    }
//
//
//    init(from decoder: Decoder) throws {
//      let container = try decoder.container(keyedBy: CodingKeys.self)
//
//      age = try container.decode(Int.self,
//                                 forKey: .age)
//
//      firebaseToken = try container.decode(String.self,
//                                           forKey: .firebaseToken)
//
//      gender = try container.decode(Int.self,
//                                    forKey: .gender)
//
//      imageAddress = try container.decode(String.self,
//                                          forKey: .imageAddress)
//
//      nickName = try container.decode(String.self,
//                                      forKey: .nickName)
//
//      pk = try container.decode(Int.self,
//                                forKey: .pk)
//
//      token = try container.decode(String.self,
//                                   forKey: .token)
//
//      login = try container.decode(Bool.self,
//                                   forKey: .login)
//    }
//  }
//}

