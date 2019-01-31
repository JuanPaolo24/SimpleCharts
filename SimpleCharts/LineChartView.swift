//
//  LineChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 25/01/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation
import CoreGraphics



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
    
    
    let valuetest: [Double] = [0, 60, 100, 50, 120, 300, 100]
    
    plotPoints(context: context, rect: rect, array: valuetest)
    
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
  
  
  
  
  
  //TODO: Fix the gridlines to not rely on the increment
  func plotPoints(context: CGContext, rect: CGRect, array: [Double]) {
    
    let firstPoint = array.first
    let connection = CGMutablePath()
    connection.move(to: CGPoint(x: Double(40), y: Double(rect.size.height - 31) - firstPoint!))
    
    
    
    
    for (i, value) in array.enumerated() {
      
      context.addArc(center: CGPoint(x: Double(40 * (i + 1)), y: Double(rect.size.height - 31) - value), radius: 5, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
      context.setLineWidth(1.0)
      context.setFillColor(UIColor.black.cgColor)
      context.fillPath()
      
      connection.addLine(to: CGPoint(x: Double(40 * (i + 1)), y: Double(rect.size.height - 31) - value))
      context.addPath(connection)

      let firstGridLine = CGMutablePath()
      firstGridLine.move(to: CGPoint(x: Double(40 * (i + 1)), y: 10))
      firstGridLine.addLine(to: CGPoint(x: Double(40 * (i + 1)), y: Double(rect.size.height - 31)))
      context.addPath(firstGridLine)
      context.setStrokeColor(UIColor.black.cgColor)
      context.strokePath()
      context.setLineWidth(0.5)
      
    }
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




