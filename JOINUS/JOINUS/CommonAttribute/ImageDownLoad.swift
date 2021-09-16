//
//  ImageDownLoad.swift
//  JOINUS
//
//  Created by Demian on 2021/09/15.
//

import UIKit

class DownLoad {
  func imageURL(image url: String) -> UIImage {
    guard let url = URL(string: url),
          let data = try? Data(contentsOf: url),
          let image = UIImage(data: data) else { fatalError("image down error") }
    
    return image
  }
}
