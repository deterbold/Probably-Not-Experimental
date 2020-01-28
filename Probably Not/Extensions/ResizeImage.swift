//
//  ResizeImage.swift
//  Probably Not
//
//  Created by Miguel Sicart on 28/01/2020.
//  Copyright © 2020 playable_systems. All rights reserved.
//

import Foundation
import UIKit
import Swift

extension UIImage
{
  func resizeImage(targetSize: CGSize) -> UIImage
  {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
  }
}
