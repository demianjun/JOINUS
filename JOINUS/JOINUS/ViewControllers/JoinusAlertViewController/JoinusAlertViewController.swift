//
//  JoinusAlertViewController.swift
//  JOINUS
//
//  Created by Demian on 2021/09/02.
//

import UIKit
import RxSwift
import Photos

class JoinusAlertViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CircleCropViewControllerDelegate {
  
  private let bag = DisposeBag(),
              changeVC = ChangeViewController()
  
  private let tapGesture = UITapGestureRecognizer(),
              duration = 0.2
  
  // MARK: Model
  
  // MARK: ViewModel
  public let onboardingViewModel = OnboardingViewModel()
  
  // MARK: View
  private let backGroundView = UIView().then {
    $0.backgroundColor = UIColor.joinusColor.defaultPhotoGray
    $0.bounds = UIScreen.main.bounds
    $0.isUserInteractionEnabled = true
    $0.alpha = 0.0
  }
  
  private let joinusActionSheetView = JoinusActionSheetView().then {
    $0.alpha = 1.0
  }
  
  private let picker = UIImagePickerController()
  
  // MARK: initialized
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  // MARK: Life Cylcle
  override func loadView() {
    super.loadView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .clear
    self.setupView()
    self.methods()
    self.didTapSelectAlbumButton()
    self.didTapChangeDefaultImageButton()
    self.didTapCancelButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.presentAnimation()
  }
    
  func setupView() {
    [backGroundView, joinusActionSheetView].forEach { self.view.addSubview($0) }
    
    backGroundView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    joinusActionSheetView.snp.makeConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-CommonLength.shared.height(17))
      $0.width.equalToSuperview().multipliedBy(0.95)
      $0.centerX.equalToSuperview()
    }
    
    self.backGroundView.addGestureRecognizer(self.tapGesture)
    self.joinusActionSheetView.transform = .init(translationX: 0,
                                                 y: CommonLength.shared.height(300))
  }
  
  // MARK: Method
  func methods() {
    self.picker.delegate = self
  }
  
  private func didTapCancelButton() {
    
    self.joinusActionSheetView
      .useCancelButton()
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.dismissAnimation()
        
      }).disposed(by: self.bag)
        
    self.tapGesture
      .rx
      .event
      .asDriver()
      .drive(onNext: { tap in
        
        self.dismissAnimation()
        
      }).disposed(by: self.bag)
  }
  
  private func didTapSelectAlbumButton() {
    self.joinusActionSheetView
      .useSelectAlbumButton()
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.requestPhotosPermission()
        
      }).disposed(by: self.bag)
  }
  
  private func didTapChangeDefaultImageButton() {
    self.joinusActionSheetView
      .useChangeDefaultImageButton()
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        let defaultImage = UIImage(named: "profile")!
        
        self.onboardingViewModel
          .selectProfileImageInputSubject
          .onNext(defaultImage)
        
        self.view
          .window?
          .rootViewController?
          .dismiss(animated: true)
        
      }).disposed(by: self.bag)
  }
  
  private func presentAnimation() {
    UIView.animate(withDuration: self.duration) {
      self.backGroundView.alpha = 1.0
    }
    
    UIView.animate(withDuration: self.duration) {
      self.joinusActionSheetView.transform = .identity
    }
  }
  
  private func dismissAnimation() {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) {
      self.dismiss(animated: false)
    }
    
    UIView.animate(withDuration: self.duration) {
      self.backGroundView.alpha = 0.0
    }
    
    UIView.animate(withDuration: self.duration) {
      self.joinusActionSheetView.transform = .init(translationX: 0,
                                                   y: CommonLength.shared.height(300))
    }
  }
  
  private func requestPhotosPermission() {
    let photoAuthorizationStatusStatus = PHPhotoLibrary.authorizationStatus()
    
    switch photoAuthorizationStatusStatus {
      case .authorized:
        print("Photo Authorization status is authorized.")
        self.requestCollection()
        
      case .denied:
        print("Photo Authorization status is denied.")
        
      case .notDetermined:
        print("Photo Authorization status is not determined.")
        PHPhotoLibrary.requestAuthorization() {
          (status) in
          switch status {
            case .authorized:
              print("User permiited.")
              self.requestCollection()
            case .denied:
              print("User denied.")
              break
              
            default:
              break
          }
        }
        
      case .restricted:
        print("Photo Authorization status is restricted.")
      default:
        break
    }
  }
  
  private func requestCollection() {
    self.picker.sourceType = .photoLibrary
    
    self.present(self.picker,
                 animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      
      let circleCropVC = CircleCropViewController(withImage: image)
      circleCropVC.modalPresentationStyle = .overFullScreen
      circleCropVC.delegate = self

      picker.dismiss(animated: true) {
        
        self.present(circleCropVC, animated: false)
        
      }
    }
  }
  
  func circleCropDidCancel() {
    
    self.dismiss(animated: true)
  }
  
  func circleCropDidCropImage(_ image: UIImage) {
    
    self.onboardingViewModel
      .selectProfileImageInputSubject
      .onNext(image)
    
    self.view
      .window?
      .rootViewController?
      .dismiss(animated: true)
  }

  func useJoinusActionSheetView() -> JoinusActionSheetView {
    return self.joinusActionSheetView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
