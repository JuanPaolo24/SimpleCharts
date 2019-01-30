//
//  LineChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 25/01/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation
import CoreGraphics


//TODO: Implement labels on both axis
//TODO: Implement points on the graph


extension FloatingPoint {
  var degreesToRadians: Self {return self * .pi / 180}
}

open class LineChartView: UIView {
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard let context = UIGraphicsGetCurrentContext() else {
      print("could not get context")
      return
    }
    
    drawPoint(context: context, rect: rect)
    
    context.addPath(yAxis(rect: rect))
    context.addPath(xAxis(rect: rect))
    context.setStrokeColor(UIColor.black.cgColor)
    context.strokePath()

  }
  
  func yAxis(rect: CGRect) -> CGPath {
    let yAxisPath = CGMutablePath()
    yAxisPath.move(to: CGPoint(x: 30, y: 10))
    yAxisPath.addLine(to: CGPoint(x: 30, y: rect.size.height - 31))
    
    return yAxisPath
  }
  
  
  func xAxis(rect: CGRect) -> CGPath {
    let xAxisPath = CGMutablePath()
    xAxisPath.move(to: CGPoint(x: 30, y: rect.size.height - 31))
    xAxisPath.addLine(to: CGPoint(x: rect.size.width - 31, y: rect.size.height - 31))
    return xAxisPath
    
  }
  
  func drawPoint(context: CGContext, rect: CGRect) {
    
    for i in 1...5 {
      context.addArc(center: linePoint(x: CGFloat(50 * i), y: rect.size.height - CGFloat(50 * i)), radius: 5, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
      
      context.setLineWidth(1.0)
      context.setFillColor(UIColor.black.cgColor)
      context.fillPath()
      
      
      context.addPath(lineConnection(xFrom: CGFloat(50 * i), yFrom: rect.size.height - CGFloat(50 * i), xTo: CGFloat(50 * i) + 50, yTo: rect.size.height - (CGFloat(50 * i) + 50)))
      context.setStrokeColor(UIColor.black.cgColor)
      context.strokePath()
      
    }
    
  }
  
  func linePoint(x: CGFloat, y: CGFloat) -> CGPoint {
    let centerPoint = CGPoint(x: x, y: y)
    
    return centerPoint
  }
  
  
  func lineConnection(xFrom: CGFloat, yFrom: CGFloat, xTo: CGFloat, yTo: CGFloat) -> CGMutablePath {
    let connection = CGMutablePath()
    connection.move(to: CGPoint(x: xFrom, y: yFrom))
    connection.addLine(to: CGPoint(x: xTo, y: yTo))
    
    return connection
  }
  
  
  
  
  func axisLabel(name: String) -> UILabel {
    let label = UILabel(frame: CGRect.zero)
    label.text = name
    label.font = UIFont.boldSystemFont(ofSize: 10)
    label.textColor = UIColor.black
    label.backgroundColor = backgroundColor
    label.textAlignment = NSTextAlignment.right
    
    return label
  }

  
  
}




