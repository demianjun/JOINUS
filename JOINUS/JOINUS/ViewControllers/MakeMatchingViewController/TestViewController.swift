//
//  File.swift
//  JOINUS
//
//  Created by Demian on 2021/09/13.
//

import UIKit

class TestViewController: UIViewController {
  private let tempView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
  }
  
  private func setupView() {
    [].forEach { self.view.addSubview($0) }
  }
}
