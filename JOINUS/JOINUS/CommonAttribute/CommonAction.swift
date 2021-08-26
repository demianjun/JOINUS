//
//  CommonAction.swift
//  JOINUS
//
//  Created by Demian on 2021/08/27.
//

import Foundation
import RxSwift

class CommonAction {
  
  enum touch {
    case down, outDrag, upInside
  }
  
  static let shared = CommonAction()
  
  private var kindOfTouch: CommonAction.touch?
  
  public let bag = DisposeBag()
  
  func touchActionEffect(_ button: UIButton,
                         handler: @escaping (() -> ())) {
    
    Observable
      .of(button.rx.controlEvent(.touchDown).map { self.kindOfTouch = .down } ,
          button.rx.controlEvent(.touchDragOutside).map { self.kindOfTouch = .outDrag },
          button.rx.controlEvent(.touchUpInside).map { self.kindOfTouch = .upInside })
      .merge()
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: {
        
        switch self.kindOfTouch {
          
          case .down:
            button.alpha = 0.6
            
          case .outDrag:
            button.alpha = 1.0
            
          case .upInside:
            button.alpha = 1.0
            handler()
            
          case .none: break
            
        }
      }).disposed(by: self.bag)
  }
}

