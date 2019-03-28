//
//  AnimationRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 27/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class AnimationRenderer: UIView {
  
  open func addAnimation(path: CGMutablePath, shapeLayer: CAShapeLayer) {
    shapeLayer.path = path
    shapeLayer.strokeColor = UIColor.red.cgColor
    shapeLayer.lineWidth = 10
    shapeLayer.strokeEnd = 0
  }
  
  open func animate() -> CABasicAnimation {
    let basicAnimation = CABasicAnimation(keyPath: "path")
  
    basicAnimation.toValue = 1
    basicAnimation.duration = 2
    basicAnimation.fillMode = CAMediaTimingFillMode.forwards
    basicAnimation.isRemovedOnCompletion = false
    
    return basicAnimation
  }
  
  
  
  
}
