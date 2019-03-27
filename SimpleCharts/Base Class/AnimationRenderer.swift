//
//  AnimationRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 27/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


class AnimationRenderer {
  
  func addAnimation(point: CGPoint) {
    let shapeLayer = CAShapeLayer()
    
    let path = CGMutablePath()
    path.move(to: point)
    
    shapeLayer.path = path
    shapeLayer.strokeColor = UIColor.red.cgColor
    shapeLayer.lineWidth = 10
    shapeLayer.strokeEnd = 0
    
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    
    basicAnimation.toValue = 1
    basicAnimation.duration = 2
    
    shapeLayer.add(basicAnimation, forKey: "basic")
    
  }
  
  
  
  
}
