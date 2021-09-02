//
//  KACircleCropViewController.swift
//  Circle Crop View Controller
//
//  Created by Keke Arif on 29/02/2016.
//  Copyright © 2016 Keke Arif. All rights reserved.
//

import UIKit
import RxSwift

protocol CircleCropViewControllerDelegate {
  
  func circleCropDidCancel()
  func circleCropDidCropImage(_ image: UIImage)
}

class CircleCropViewController: UIViewController, UIScrollViewDelegate {
  
  let bag = DisposeBag()
  
  var delegate: CircleCropViewControllerDelegate?
  
  var image: UIImage
  let imageView = UIImageView()
  
  let scrollView = CircleCropScrollView()
  let cutterView = CircleCropCutterView()
  
  let okButton = UIButton()
  let backButton = UIButton()
  
  let length = CommonLength.shared.width(300)
  
  init(withImage image: UIImage) {
    self.image = image
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: View management
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .black.withAlphaComponent(0.8)
    
    self.imageView.image = image
    self.imageView.frame = CGRect(origin: CGPoint.zero,
                                  size: image.size)
    self.scrollView.delegate = self
    self.scrollView.addSubview(imageView)
    self.scrollView.contentSize = image.size
    
    let scaleWidth = self.length / scrollView.contentSize.width
    self.scrollView.minimumZoomScale = scaleWidth
    
    if self.imageView.frame.size.width < self.length {
      
      print("We have the case where the frame is too small")
      self.scrollView.maximumZoomScale = scaleWidth * 2
      
    } else {
      
      self.scrollView.maximumZoomScale = 1.0
    }
    
    self.scrollView.zoomScale = scaleWidth
    self.scrollView.contentOffset = CGPoint(x: 0, y: (self.scrollView.contentSize.height - self.length)/2)
    
    //Add the label and buttons
    self.okButton.setTitle("자르기",
                      for: .normal)
    self.okButton.setTitleColor(UIColor.white,
                           for: .normal)
    self.okButton.titleLabel?.font = UIFont.joinuns.font(size: 15)
    
    self.okButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.didTapOk()
        
      }).disposed(by: self.bag)
      
    backButton.setTitle("취소",
                        for: .normal)
    backButton.setTitleColor(UIColor.white,
                             for: .normal)
    backButton.titleLabel?.font = UIFont.joinuns.font(size: 15)
    backButton
      .rx
      .tap
      .asDriver()
      .drive(onNext: {
        
        self.didTapBack()
        
      }).disposed(by: self.bag)
    
    view.addSubview(scrollView)
    view.addSubview(cutterView)
    
    cutterView.addSubview(okButton)
    cutterView.addSubview(backButton)
    
    scrollView.snp.makeConstraints {
      $0.width.height.equalTo(CommonLength.shared.width(300))
      $0.center.equalToSuperview()
    }
    
    cutterView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    okButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(150))
      $0.trailing.equalToSuperview().offset(-CommonLength.shared.width(50))
      $0.width.height.equalTo(CommonLength.shared.width(50))
    }
    
    backButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-CommonLength.shared.height(150))
      $0.leading.equalToSuperview().offset(CommonLength.shared.width(50))
      $0.width.height.equalTo(CommonLength.shared.width(50))
    }
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    
    coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
      
//      self.setLabelAndButtonFrames()
      
    }) { (UIViewControllerTransitionCoordinatorContext) -> Void in
      
    }
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  override var prefersStatusBarHidden : Bool {
    return true
  }
  
  // MARK: Button taps
  
  func didTapOk() {
    
    let newSize = CGSize(width: image.size.width * scrollView.zoomScale, height: image.size.height * scrollView.zoomScale)
    
    let offset = scrollView.contentOffset
    
    UIGraphicsBeginImageContextWithOptions(CGSize(width: self.length,
                                                  height: self.length), false, 0)
    
    let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0,
                                                 width: self.length,
                                                 height: self.length))
    
    circlePath.addClip()
    
    var sharpRect = CGRect(x: -offset.x, y: -offset.y, width: newSize.width, height: newSize.height)
    
    sharpRect = sharpRect.integral
    
    image.draw(in: sharpRect)
    
    let finalImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    if let imageData = finalImage!.pngData() {
      
      if let pngImage = UIImage(data: imageData) {
        
        delegate?.circleCropDidCropImage(pngImage)
        
      } else {
        
        delegate?.circleCropDidCancel()
      }
    } else {
      
      delegate?.circleCropDidCancel()
    }
  }
  
  func didTapBack() {
    
    delegate?.circleCropDidCancel()
    
  }
}
