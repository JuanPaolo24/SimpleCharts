//
//  LineChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 25/01/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation
import CoreGraphics


open class LineChartView: UIView {
  
  
  private var context : CGContext?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    
    context = UIGraphicsGetCurrentContext()
    

    context!.addPath(yAxis(rect: rect))
    context!.addPath(xAxis(rect: rect))
    context!.setStrokeColor(UIColor.black.cgColor)
    context!.strokePath()
    
    
  }
  
  func yAxis(rect: CGRect) -> CGMutablePath {
    let yAxisPath = CGMutablePath()
    yAxisPath.move(to: CGPoint(x: 30, y: 10))
    yAxisPath.addLine(to: CGPoint(x: 30, y: rect.size.height - 31))
    
    return yAxisPath
  }
  
  
  func xAxis(rect: CGRect) -> CGMutablePath {
    let xAxisPath = CGMutablePath()
    xAxisPath.move(to: CGPoint(x: 30, y: rect.size.height - 31))
    xAxisPath.addLine(to: CGPoint(x: rect.size.width - 31, y: rect.size.height - 31))
    return xAxisPath
    
  }
  

  
  
}




