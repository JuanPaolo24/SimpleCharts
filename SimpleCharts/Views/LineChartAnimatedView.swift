//
//  LineChartAnimatedView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 18/04/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

open class LineChartAnimatedView: UIView {
  
  
  
  override open func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    let shapelayer = CAShapeLayer()
    let bounds = CGRect(x: 50, y: 50, width: 250, height: 250)
    shapelayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 20, height: 20)).cgPath
    shapelayer.strokeColor = UIColor.blue.cgColor
    shapelayer.fillColor = nil
    shapelayer.lineDashPattern = [8, 6]
    layer.addSublayer(shapelayer)
    
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = 2
    animation.autoreverses = true
    animation.repeatCount = .infinity
    shapelayer.add(animation, forKey: "line")
  }
  
}
